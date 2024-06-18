from inject import Inject
from slack_api import SlackAPI
from typing import List
from yaml import full_load


class Scheduler:

    @staticmethod
    def load_injects(inject_file: str) -> List[Inject]:
        injects = []

        with open(inject_file) as fd:
            yaml_contents = full_load(fd)

            for inject_content in yaml_contents:
                if inject_content['enabled'] == True:
                    inject_obj = Inject(
                        title=inject_content['title'],
                        description=inject_content['description'],
                        start_time=inject_content['start_time'],
                        end_time=inject_content['end_time']
                    )

                    injects.append(inject_obj)

        return injects

    @staticmethod
    def schedule_inject(inject: Inject) -> None:
        slack_api = SlackAPI()
        slack_api.schedule_message(inject.start_description, inject.start_time)
        slack_api.schedule_message(inject.end_description, inject.end_time)


if __name__ == '__main__':
    injects_file = "injects.yaml"

    for inject in Scheduler.load_injects(injects_file):
        Scheduler.schedule_inject(inject)

