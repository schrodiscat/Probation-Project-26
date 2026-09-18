import random

password = str(random.randint(100, 999))

print("PASSWORD CRACKER GAME")
print("You have Five attempts to crack the password.")

for attempt in range(1, 6):
    guess = input("Enter Your Guessing Password : ")

    if len(guess) != 3 or not guess.isdigit():
        print("Invalid Input! Enter a 3-digit Number.")
        continue

    for i in range(3):
        if guess[i] == password[i]:
            print(guess[i], "is correct and it is in the correct position.")
        elif guess[i] in password:          
            print(guess[i], "is correct but in the wrong position.")
        else:
            print(guess[i], "is not present in the password")
    if guess == password:
        print("CONGRATULATIONS! YOU CRACKED THE PASSWORD")
        print("Attempts Taken By You : ", attempt)
        break

else:
    print("GAME OVER!")
    print("The password was : ", password)