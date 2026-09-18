import random
def main():
    l1= ["python", "machine", "learning", "data", "science"]
    guessword= random.choice(l1)
    print("Welcome to Guessing Game")
    print("You will get 6 chances to guess the word correctly")
    length=len(guessword) #To store the length of the word
    max_attempt=6
    display_words= ["_"]*length #List to show the output of the guessword
    while(max_attempt>0):
        print("Word :", " ".join(display_words))
        guess=input("Enter your guess ").lower()
        if len(guess) !=1 or not guess.isalpha():
            print("Enter a single alphabet")
            continue
        if guess in guessword:
            print("Correct")
            for i in range(length):
                if guessword[i]==guess:
                    display_words[i]=guess
            if "_" not in display_words:
                print("You Win")
                break
        else:
            print("Incorrect")
            max_attempt-=1
            print("Attempts Left =",max_attempt)
    if max_attempt==0:
        print("You Lose")
        print("Correct word is ",guessword)
main ()