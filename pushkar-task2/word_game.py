import random 

words =["python", "machine", "learning", "data", "science"]
secret = random.choice(words)

chances = 6
display_word = ["_"]* len(secret)


print("welcome to the word guessing game !")
print("guess the secret word one letter at a time.")
print("you have",chances,"chances.\n")

while chances > 0 and "_" in display_word :
    print("Word:"," ".join(display_word))
    guess = input("guess a letter : ").lower()
    
    if len(guess) != 1 or not guess.isalpha():
        print("print enter a single alphabet.\n")
        continue 
    
    if guess in secret :
        print("correct!")
        for i in range(len(secret)):
            if secret[i] == guess :
                display_word[i] = guess 
    else :
        chances -= 1
        print("wrong guess ! chances left:",chances)
        

if "_" not in display_word :
    print("congratulation! you guessed the word: ",secret)
else :
    print("out of chances.the word was:",secret)
