import math
from player import Player
from utilities import distance, closest_to_point, circle_line_intersection, circle_collision

class Orbwalker:
    def __init__(self, player: Player):
        self.player = player

    def orbwalk(self, target, game_map):
        self.target = target
        target_pos = target.get_position()
        player_pos = self.player.get_position()
        dist = distance(player_pos, target_pos)

        if dist > self.player.get_range():
            closest = closest_to_point(player_pos, game_map.get_points())
            self.move_to(closest)
        else:
            target_angle = math.atan2(target_pos[1] - player_pos[1], target_pos[0] - player_pos[0])
            self.player.attack(target)
            self.kite(target_angle, target_pos, player_pos)

    def move_to(self, position):
        self.player.move(position)

    def kite(self, target_angle, target_pos, player_pos):
        speed = self.player.get_move_speed()
        target_range = self.player.get_range()
        distance_to_target = distance(target_pos, player_pos)
        angle_to_target = math.atan2(target_pos[1] - player_pos[1], target_pos[0] - player_pos[0])
        perpendicular_angle = target_angle - math.pi / 2
        back_pos = (player_pos[0] + speed * math.cos(angle_to_target),
                    player_pos[1] + speed * math.sin(angle_to_target))
        if distance_to_target < target_range / 2:
            if distance_to_target < target_range / 4:
                move_pos = (player_pos[0] + speed * math.cos(target_angle),
                            player_pos[1] + speed * math.sin(target_angle))
                self.move_to(move_pos)
            else:
                move_pos = (player_pos[0] + speed * math.cos(perpendicular_angle),
                            player_pos[1] + speed * math.sin(perpendicular_angle))
                self.move_to(move_pos)
        elif distance_to_target > target_range:
            move_pos = (player_pos[0] + speed * math.cos(target_angle + math.pi),
                        player_pos[1] + speed * math.sin(target_angle + math.pi))
            self.move_to(move_pos)
        else:
            intersect = circle_line_intersection(player_pos, back_pos, target_pos, target_range)
            if intersect is not None:
                back_dist = distance(player_pos, intersect)
                if back_dist < distance_to_target:
                    move_pos = intersect
                    self.move_to(move_pos)
                else:
                    move_pos = (player_pos[0] + speed * math.cos(perpendicular_angle),
                                player_pos[1] + speed * math.sin(perpendicular_angle))
                    self.move_to(move_pos)
            else:
                collision = circle_collision(player_pos, back_pos, target_pos, target_range)
                if collision is not None:
                    move_pos = collision
                    self.move_to(move_pos)
                else:
                    move_pos = (player_pos[0] + speed * math.cos(perpendicular_angle),
                                player_pos[1] + speed * math.sin(perpendicular_angle))
                    self.move_to(move_pos)
