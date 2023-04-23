def shortestCommonSuperSequence(s1, s2):
    m, n = len(s1), len(s2)
    res = [[''] * (n + 1) for _ in range(2)]

    ### initilazation
    for i in range(1, n + 1):
        res[0][i] = res[0][i - 1] + s2[i - 1]

    
    row = 0
    print(res[0])

    for i in range(1, m + 1):
        row = 1 - row

        for j in range(n + 1):
            if j == 0:
                res[row][j] = res[1 - row][j] + s1[i - 1]
            else:
                if s1[i - 1] == s2[j - 1]:
                    res[row][j] = res[1 - row][j - 1] + s1[i - 1]
                else:
                    res[row][j] = min(res[1 - row][j] + s1[i - 1], res[row][j - 1] + s2[j - 1], key=len)
    return res[row][-1]



print(shortestCommonSuperSequence('abac', 'cab'))