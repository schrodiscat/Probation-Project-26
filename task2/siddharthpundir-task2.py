import random

l = ["python", "machine", "learning", "data", "science"]
word = random.choice(l)

dash = ['_'] * len(word)
attempt = 6

while (attempt != 0 and ''.join(dash) != word):

    guess = input("Enter a character: ")

    if (len(guess) == 1 and guess.isalpha()):

        if guess in word:
            print("Correct guess")

            for i in range(len(word)):
                if word[i] == guess:
                    dash[i] = guess

            print(' '.join(dash))

        else:
            print("Character is not in the word")
            attempt -= 1
            print(f"You have {attempt} attempts left\n")

    else:
        print("Enter a valid character")

if ''.join(dash) == word:
    print("You won! ")
else:
    print(f"You lost! The word was {word}")