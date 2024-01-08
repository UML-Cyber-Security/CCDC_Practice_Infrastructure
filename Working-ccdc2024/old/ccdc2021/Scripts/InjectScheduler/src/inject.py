class Inject:

    __AUTO_ID = 0

    def __init__(
            self, title: str, description: str, start_time: str, end_time: str
    ):
        Inject.__AUTO_ID += 1

        self.__id = "INJECT-" + str(Inject.__AUTO_ID)
        self.__title = title
        self.__description = description
        self.__start_time = start_time
        self.__end_time = end_time

    @property
    def start_time(self) -> str:
        return self.__start_time

    @property
    def end_time(self) -> str:
        return self.__end_time

    @property
    def start_description(self) -> str:
        return f"```" \
               f"New Inject ->      {self.__id}\n" \
               f"   Title ->        {self.__title}\n" \
               f"   Description ->  {self.__description}\n" \
               f"   Start Time ->   {self.__start_time}\n" \
               f"   End Time ->     {self.__end_time}" \
               f"```"

    @property
    def end_description(self) -> str:
        return f"```" \
               f"Inject {self.__id} Overdue" \
               f"```"

