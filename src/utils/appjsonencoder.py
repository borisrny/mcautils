import json
from datetime import datetime, time
import pytz


class DateTimeJSONEncoder(json.JSONEncoder):
    ltz = pytz.timezone('US/Eastern')
    offset = ltz.utcoffset(datetime.now())
    dt_offset = time(offset.days * -24 - int(offset.seconds / 60 / 60))

    def default(self, obj):
        if obj.__class__.__name__ in ['date', 'datetime']:
            new_obj = DateTimeJSONEncoder.ltz.localize(datetime.combine(obj, DateTimeJSONEncoder.dt_offset))
            return new_obj.isoformat()
        else:
            return super(DateTimeJSONEncoder, self).default(obj)
