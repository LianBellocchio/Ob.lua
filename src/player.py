import random


class Player:
    def __init__(self, name):
        self.name = name
        self.position = (0, 0)
        self.health = 100
        self.mana = 100
        self.items = []
    
    def move_to(self, x, y):
        self.position = (x, y)
    
    def use_item(self, item):
        if item in self.items:
            self.items.remove(item)
            item.use(self)
    
    def kite(self, enemy):
        if self.position[0] - enemy.position[0] > 0:
            self.move_to(self.position[0] + 1, self.position[1])
        else:
            self.move_to(self.position[0] - 1, self.position[1])
