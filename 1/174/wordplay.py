import random

def signature(word):
    """ Returns the signature of this word, which is a tuple that contains
    all of the the letters in order.
    """
    l = list(word)
    l.sort()
    s = tuple(l)
    return s

def anagrams(word1, word2):
    """ Returns True if the two words are anagrams.
    """
    return signature(word1) == signature(word2)

def pronunciation(word, say):
    """ Returns the pronunciation of this word, which is a string.
    If the pronunciation is unknown, returns empty string.
    The second parameter is a a dictionary that maps words to pronunciations.
    """
    if word in say:
        return say[word]
    else:
        return ''

def all_anagrams():
    """ Returns a dictionary that maps each signature to a list of anagrams.
    """
    anagram = dict()
    fwords = open("words.txt","r")
    for word in fwords:
        word = word.strip()
        s = signature(word)
        if s in anagram:
            anagram[s].append(word)
        else:
            anagram[s] = [word]
    fwords.close()
    return anagram
   
def all_homophones():
    """ Returns a dictionary that maps words to their pronunciations.
    """
    say = dict()
    fp = open("cmu1.txt","r")
    for line in fp:
        line = line.strip()
        [word, pron] = line.split(':')
        say[word] = pron
    fp.close()
    return say

def invert_dict(d):
    """ Returns an inverted dictionary.
    """
    inv = dict()
    for key in d:
        val = d[key]
        if val not in inv:
            inv[val] = [key]
        else:
            inv[val].append(key)
    return inv

def random_swap(word):
    """ Returns a word with a pair of internal letters swapped;
    returns the word unchanged if the word is too short or contains 
    uppercase letters or punctuation.
    """
    wlen = len(word)
    if word.islower() and word.isalpha() and wlen >= 6:
        l = list(word)
        rind = random.randint(3,wlen-3)
        l[rind],l[rind+1] = l[rind+1],l[rind]
        return ''.join(l)
    else:
        return word
   
