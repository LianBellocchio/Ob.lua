class Champion:
    def __init__(self, name, attack_range):
        self.name = name
        self.attack_range = attack_range

    def can_attack(self, player, target):
        return player.team != target.team and get_distance(player.pos, target.pos) <= self.attack_range

    def attack(self, player, target):
        print(f"{player.name} attacks {target.name}")
        target.receive_damage(50)
