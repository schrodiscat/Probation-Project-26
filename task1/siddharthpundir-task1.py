import random
realpass = str(random.randint(100, 999))

print('========================================')
print("Welcome to the Password Cracker Game")
print('========================================')

attempts = 5

for i in range(attempts):
    password = input("Enter a 3-digit password: ")

    if len(password) != 3:
        print("Invalid input! Please enter exactly 3 digits.")
        continue

    if password == realpass:
        print(f" Congratulations! You cracked the password in {i+1} attempts.")
        break

    for j in range(len(password)):
        if password[j] == realpass[j]:
            print(f"{password[j]} is correct and in the correct position.")
        elif password[j] in realpass:
            print(f"{password[j]} is correct but in the wrong position.")
        else:
            print(f"{password[j]} is not present in the password.")

    print(f" Wrong guess! You have {attempts - i - 1} attempts remaining.\n")

else:

    print(f"Game Over! The correct password was {realpass}.")