import sys
import string

#reading the input file "cats_txt"
cats = open('cats_txt.txt', "r")

#defining the function
def word_and_punct_count(words_file):
    #initializing the results objects
    all_punctuation=""
    punct_freq={}
    words_freq={}
    #lines=open('words_file', "r")
    for line in words_file:
        #lowercase each line
        lower_case=line.lower()
        #split lines into words
        words=lower_case.split()

        #count the punctuation and saving the count into the punct_freq dictionary
        punctuation = string.punctuation
        for item in line:
            if item in punctuation:
                all_punctuation=all_punctuation+item

        for punct in all_punctuation:
            if punct in punct_freq:
                punct_freq[punct]+=1
            else:
                punct_freq[punct]=1

        #counting the words and saving the count into the words_freq dictionary
        for word in words:
            if word in words_freq:
                words_freq[word]+=1
            else:
                words_freq[word]=1

        #sorting punctuation and words counts by their count in a descending order
        punct_sorted=sorted(punct_freq.items(), key = lambda kv:(kv[1], kv[0]), reverse = True)
        words_sorted=sorted(words_freq.items(), key = lambda kv:(kv[1], kv[0]), reverse = True)

    #returning the sorted lists
    return punct_sorted, words_sorted


#if __name__ == "__main__": #if the file name is name __main__ then teh file being is the thing atht's 
#being executed in the terminal

print(word_and_punct_count(cats))#calling the function

   

 