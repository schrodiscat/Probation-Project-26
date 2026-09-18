import random
def hint(password, guess):
    for i in range(3):
        digit = guess[i]
        if digit == password[i]:
            print(digit + " is correct")
        elif digit in password:
            print( digit + " is correct but in the wrong place")
        else:
            print (digit + " is not in the password")
def main():
    print("Welcome to Password Cracker")
    print("You will get 5 chances to crack the password")
    print("-"*40)
    password=f"{random.randint(0,999):03d}"
    max_attempt=5
    current=0
    guess_correctly=False
    while(max_attempt>current):
        current +=1
        print(f"{current} attempt ")
        guess= input("Enter you guess ").strip()
        
        #To check that the guess is purely a 3 digit number and not any alphabet
        if not( guess.isdigit() and len(guess)==3):
            print ("Please enter only numbers Eg.- 023, 345, 735 etc")
            current -=1
            continue
        if guess == password:
            print("Congratulations")
            guess_correctly=True
            break
        else:
            print("Hints")
            hint(password, guess)
            print("-"*40)
    
    if not guess_correctly:
        print("Game over")
        print("Correct password is "+password)
main()