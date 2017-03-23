


def sum(n):
    if n==1:
        return 1
    elif n>1:
        return 1/n+sum(n-1)

print(sum(2))