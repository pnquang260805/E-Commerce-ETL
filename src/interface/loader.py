from abc import ABC, abstractmethod


class Loader(ABC):
    @abstractmethod
    def load(self, table, data):
        pass
