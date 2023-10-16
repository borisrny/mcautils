import logging
from pymongo import monitoring


class MongoCmdMonitor(monitoring.CommandListener):

    def __init__(self):
        self._lg = logging.getLogger(__name__)
        self._do_log = self._lg.debug


    def started(self, event):
        self._do_log("Command {0.command_name} "
                     "Command {0.command} with request id "
                     "{0.request_id} started".format(event))


    def succeeded(self, event):
        self._do_log("Command with request id "
                     "{0.request_id} "
                     "succeeded in {0.duration_micros} "
                     "microseconds".format(event))


    def failed(self, event):
        self._do_log("Command with request id "
                     "{0.request_id} "
                     "failed in {0.duration_micros} "
                     "microseconds".format(event))
