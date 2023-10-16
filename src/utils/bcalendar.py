from builtins import object
from datetime import datetime, timedelta
from business_calendar import Calendar, FOLLOWING
from objcache import objcache_get_entire_table
from dateutil.relativedelta import relativedelta

from appexcept import AppLogicalError


class RecurringFrequency:
    DAILY = 'Daily'
    WEEKLY = 'Weekly'
    BI_WEEKLY = 'Bi-Weekly'
    MONTHLY = 'Monthly'


class BCalendar(Calendar):
    FREQUENCIES = {
        1: RecurringFrequency.DAILY,
        5: RecurringFrequency.WEEKLY,
        10: RecurringFrequency.BI_WEEKLY,
        -1: RecurringFrequency.MONTHLY
    }

    def to_frequency(self, v):
        if v not in self.FREQUENCIES:
            raise AppLogicalError(-1, f'Unexpected frequency value {v}')

        return self.FREQUENCIES[v]

    def to_value(self, freq):
        frequencies = {v: k for k, v in self.FREQUENCIES.items()}
        if freq not in frequencies:
            raise AppLogicalError(-1, f'Unexpected frequency {freq}')

        return frequencies[freq]

    def generate_payment_trans_dates(self, init_date, freq, trans_count,
                                     skip_start=None, skip_end=None):
        if not self.isworkday(init_date) and freq != RecurringFrequency.MONTHLY:
            init_date_obj = self.adjust(init_date, FOLLOWING)
        else:
            init_date_obj = self.addworkdays(init_date, 0)

        offset = 0
        date_list = []
        is_monthly = freq == RecurringFrequency.MONTHLY

        while True:
            if is_monthly:
                next_date = init_date_obj + relativedelta(months=offset)
            else:
                next_date = self.addworkdays(init_date_obj, offset * self.to_value(freq))

            offset += 1

            if skip_start and skip_end and next_date >= skip_start \
                    and next_date <= skip_end:
                continue

            if not self.isbusday(next_date):
                next_date = self.addbusdays(next_date, 1)
            date_list.append(next_date)

            if len(date_list) >= trans_count:
                break

        return date_list


class Calendars(object):
    calendars = {}

    @staticmethod
    def get_calendar(cnf, country):
        ret = Calendars.calendars.get(country)
        if not ret:
            ret = Calendars.init(cnf, country)
            Calendars.calendars[country] = ret
        return ret

    @staticmethod
    def init(cnf, country):
        holidays_table = objcache_get_entire_table(cnf, 'holidays')
        holidays = [Calendars._to_datetime(holiday['date']) for holiday in holidays_table if
                    holiday['country'] == country]
        return BCalendar(holidays=holidays)

    @staticmethod
    def _to_datetime(dt):
        return datetime(dt.year, dt.month, dt.day, 0, 0, 0)

    @staticmethod
    def get_weekdays_count(start, end):
        days = (end - start).days + 1
        weeks = days // 7
        reminder_days = days % 7
        days -= weeks * 2
        if reminder_days:
            weekdays = set(range(end.isoweekday(), end.isoweekday() - reminder_days, -1))
            days -= len(weekdays.intersection([7, 6, 0, -1]))
        return days

    @staticmethod
    def add_weekdays(start, b_days):
        weeks = b_days // 5
        reminder_days = b_days % 5
        days = b_days + weeks * 2
        end = start + timedelta(days=days)
        if reminder_days:
            weekdays = set(range(end.isoweekday(), end.isoweekday() - reminder_days, -1))
            days = len(weekdays.intersection([7, 6, 0, -1]))
            end = end + timedelta(days=days)
        return end
