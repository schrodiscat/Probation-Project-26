import random

# Generate a random 3-digit password
password = str(random.randint(100, 999))

max_attempts = 5

print("===== PASSWORD CRACKER GAME =====")
print("Crack the 3-digit password!")
print("You have 5 attempts.\n")

for attempt in range(1, max_attempts + 1):

    # Take a valid 3-digit guess
    while True:
        guess = input(f"Attempt {attempt}/5 - Enter a 3-digit password: ")

        if guess.isdigit() and len(guess) == 3 and guess[0] != '0':
            break
        else:
            print("Invalid input! Please enter a valid 3-digit number.\n")

    # Check if password is correct
    if guess == password:
        print("\n🎉 Congratulations!")
        print("You cracked the password:", password)
        print("Attempts taken:", attempt)
        break

    print("\nIncorrect password. Hints:")

  # Give hints

    for i in range(3):
        if guess[i] == password[i]:
            print(guess[i], "is correct and in the correct position.")

        elif guess[i] in password:
            print(guess[i], "is correct but in the wrong position.")

        else:
            print(guess[i], "is not present in the password.")

else:
    print("Game Over!")
    print("The correct password was:", password)