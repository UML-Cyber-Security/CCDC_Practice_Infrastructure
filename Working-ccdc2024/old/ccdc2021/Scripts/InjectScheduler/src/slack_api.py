from slack import WebClient
from time import mktime, strptime


class SlackAPI:

    def __init__(self):

        # typically, this token should be input more securely but we do not care
        # for our setup.
        self.__token = "xoxb-1404111140768-1686567099207-3sX41yOJRJcBk2L2ZhUtPaNG"

    def schedule_message(self, message: str, time: str) -> None:
        # the 18000 below is the difference in seconds between GMT and EST. the
        # time in epoch is in GMT, however, slack uses local time.
        time_in_epoch = int(mktime(strptime(time, '%m-%d-%Y %H:%M:%S'))) + 18000

        client = WebClient(token=self.__token)
        client.chat_scheduleMessage(
            channel="#injects",
            text=message,
            post_at=str(time_in_epoch)
        )

