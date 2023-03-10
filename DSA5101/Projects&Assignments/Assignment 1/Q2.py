def topologialSort(edges):

    incoming, pointing = {}, {}
    res, single = [], []

    for node1, node2 in edges:
        if node1 not in incoming:
            incoming[node1] = 0
        if node2 not in incoming:
            incoming[node2] = 0
        incoming[node2] += 1

        if node1 not in pointing:
            pointing[node1] = []
        if node2 not in pointing:
            pointing[node2] = []
        pointing[node1].append(node2)
    
    single = [key for key, val in incoming.items() if val == 0]
    
    while single:
        node = single.pop()
        incoming.pop(node)
        res.append(node)
        for edge in pointing[node]:
            incoming[edge] -= 1
            if incoming[edge] == 0:
                single.append(edge)

    if len(incoming) > 0:
        return ['graph has at least one cycle']
    else:
        return res
    



if __name__ == '__main__':
    fin = open('./graph.txt', 'rt')
    fout = open('./topological_sort.txt', 'wt')
    edges = [edge.strip() for edge in fin.readlines()]
    fin.close()
    edges = [edge.split(',') for edge in edges]

    res = topologialSort(edges)

    res = ', '.join(res)
    fout.write(res)
    fout.close()
    