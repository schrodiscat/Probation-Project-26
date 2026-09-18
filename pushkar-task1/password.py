import random


MAX_ATTEMPTS = 5

def give_hints(password, guess):

    hints = []

    for i in range(len(guess)):
        if guess[i] == password[i]:
            hints.append(f"{guess[i]} is correct and in the right spot.")
        elif guess[i] in password:
            hints.append(f"{guess[i]} is in the password but wrong spot.")
        else:
            hints.append(f"{guess[i]} is not in the password.")
    return hints

def play_game():

    secret = str(random.randint(100, 999))
    attempts = 0

    print("Password Cracker Game!")
    print(f"Try to guess the 3-digit password in {MAX_ATTEMPTS} attempts.")

    while attempts < MAX_ATTEMPTS:
        guess = input(f"\nAttempt {attempts + 1}: Enter a 3-digit number: ")

        attempts += 1

        if not (guess.isdigit() and len(guess) == 3):
            print("💀 Please enter exactly 3 digits (like 123).")
            continue



        if guess == secret:
            print(f"😍 Correct! You cracked the password in {attempts} tries.")
            return


        print("Incorrect guess. Here are your hints:")
        for hint in give_hints(secret, guess):
            print("*", hint)

    print(f"💀 Out of attempts. The password was {secret}.")


play_game()
