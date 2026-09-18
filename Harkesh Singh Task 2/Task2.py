import random

words = ["python", "machine", "learning", "data", "science"]

word = random.choice(words)

chances = 6

print("SECRET WORD GAME")
print("You have 6 chances to guess the word.")

hidden_word = ["_"]*len(word)

while chances > 0:
    print(" ".join(hidden_word))
    guess_letter = input("Enter a letter : ").lower()

    if len(guess_letter)!=1 or not guess_letter.isalpha():
        print("Please Enter only one ALPHABET.")
        continue

    if guess_letter in word:
        print("Correct Guessing")

        for i in range(len(word)):
            if word[i]== guess_letter:
                hidden_word[i] = guess_letter
    else:
        chances -= 1
        print("wrong Guess! Chances Left : ",chances)            

    if "_" not in hidden_word:
        print("Congratulations! You guessed the CORRECT word :",word)
        break
if "_" in hidden_word:
    print("Game Over! The word was :", word)
