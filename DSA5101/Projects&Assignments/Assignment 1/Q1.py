def SCS(s1, s2):
    m, n = len(s1), len(s2)
    res = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(m + 1):
        for j in range(n + 1):
            if i == 0 and j == 0:
                continue
            elif i == 0:
                res[i][j] = res[i][j - 1] + 1
            elif j == 0:
                res[i][j] = res[i - 1][j] + 1
            else:
                if s1[i - 1] == s2[j - 1]:
                    res[i][j] = res[i - 1][j - 1] + 1
                else:
                    res[i][j] = min(res[i - 1][j] + 1, res[i][j - 1] + 1)
    ans, i, j = '', m, n
    while len(ans) < res[-1][-1]:
        if i == 0:
            ans += s2[j - 1]
            j -= 1
        elif j == 0:
            ans += s1[i - 1]
            i -= 1
        elif s1[i - 1] == s2[j - 1]:
            ans += s1[i - 1]
            i -= 1
            j -= 1
        else:
            if res[i - 1][j] < res[i][j - 1]:
                ans += s1[i - 1]
                i -= 1
            else:
                ans += s2[j - 1]
                j -= 1
    return ans[::-1]



if __name__ == '__main__':
    fin = open('./Two_strings.txt', 'rt')

    strings = [line.strip() for line in fin.readlines()]
    fin.close()

    print(SCS(strings[0], strings[1]))
