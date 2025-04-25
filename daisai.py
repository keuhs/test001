#!/usr/bin/python3

import random

# 최대 돈을 저장할 변수
max_money = 0

# 주사위를 굴리는 함수
def roll_dice():
    return random.randint(1, 6)

# 주사위 세 개의 합이 홀수인지 짝수인지 확인하는 함수
def evenodd(dice1, dice2, dice3):
    if (dice1 + dice2 + dice3) % 2:
        return True  # 홀수인 경우
    else:
        return False  # 짝수인 경우

# 다이사이 게임 함수
def daisai(money):
    i = 0
    global max_money
    max_money = money  # 초기 돈을 최대 돈으로 설정
    while(money > 0):  # 돈이 남아 있는 동안 게임 진행
        bet = 1  # 초기 베팅 금액
        while True:
            if money - bet < 0:  # 베팅 금액이 현재 돈보다 많으면 중단
                break

            money = money - bet  # 베팅 금액을 현재 돈에서 차감
            print('current game is %dth' % i)
            i = i + 1

            # 주사위 세 개를 굴림
            dice1, dice2, dice3 = roll_dice(), roll_dice(), roll_dice()
            if evenodd(dice1, dice2, dice3):  # 주사위 합이 홀수인 경우
                money = money + bet * 2  # 베팅 금액의 두 배를 돌려받음
                if max_money < money:  # 최대 돈 갱신
                    max_money = money

                print('you won! you bet %d' % bet)
                break

            print('current money %d bet %d' % (money, bet))
            bet = bet * 2  # 베팅 금액을 두 배로 증가
            if bet > 128:  # 베팅 금액이 128을 초과하면 중단
                break

        print('current your total money is %d' % money)

# 초기 돈 30으로 다이사이 게임 시작
daisai(30)
print('max_money: %d' % max_money)
