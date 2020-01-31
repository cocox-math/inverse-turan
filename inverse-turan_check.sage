# Builds all k-edge subgraphs of G, up to isomorphism
def SUBGRAPHS(G,k):
    E = Set(G.edges())
    SUB = []
    for s in Subsets(E,k):
        H = Graph()
        H.add_edges(s)
        Hcan = H.canonical_label()
        if Hcan not in SUB:
            SUB.append(Hcan)
    return SUB

# Returns 1 if there is a k-edge subgraph of G which is H-free and 0 otherwise
# Note that ex(G,H)<k if and only if ex(G,H,k)=0
def ex(G,H,k):
    L = []
    for h in SUBGRAPHS(G,k):
        if h.subgraph_search(H,induced=false) == None:
            L.append(h)
            break
    return len(L)

# Path on three edges
P3 = graphs.PathGraph(4)

# K_{k-1}^*(1,...,1)
def pendant(k):
    G=graphs.CompleteGraph(k-1)
    for v in range(k-1):
        v1 = v + k
        G.add_edge([v,v1])
    return G


## k=4: Any viable graphs must be connected with |E|={4\choose 2} and \Delta\leq 3
print "Checking k=4..."
G4 = []
for n in [4..7]:
    for g in graphs.nauty_geng("{0} -c -D3 6:6".format(n)):
        if ex(g,P3,4) == 0:
            print "Found!"
            if g.is_isomorphic(graphs.CompleteGraph(4)):
                print "G = K_4"
            elif g.is_isomorphic(graphs.CompleteBipartiteGraph(2,3)):
                print "G = K_{2,3}"
            elif g.is_isomorphic(pendant(4)):
                print "G = K_3^*(1,1,1)"
            else:
                print "G is not one of the claimed extremal graphs"
            print
            G4.append(g)

## k=5: Any viable graphs must be connected with |E|={5\choose 2} and \Delta\leq 4
print "Checking k=5..."
G5 = []
for n in [5..11]:
    for g in graphs.nauty_geng("{0} -c -D4 10:10".format(n)):
        if ex(g,P3,5) == 0:
            print "Found!"
            if g.is_isomorphic(graphs.CompleteGraph(5)):
                print "G = K_5"
            elif g.is_isomorphic(pendant(5)):
                print "G = K_4^*(1,1,1,1)"
            else:
                print "G is not one of the claimed extremal graphs"
            print
            G5.append(g)

## k=6: Any viable graphs must be connected and have |E|\in\{ {6\choose 2}, {6\choose 2}+1 \}, |V|\leq 10 and \Delta=5
##      Additionally, any viable G must have a triangle T such that G[V\setminus T]=P_3,C_4, possibly with isolated vertices
print "Checking k=6..."
G6 = []
for n in [6..10]:
    for g in graphs.nauty_geng("{0} -c -D5 15:16".format(n)):
        if 5 in g.degree_sequence():
            T = g.subgraph_search(graphs.CompleteGraph(3),induced=false)
            if T != None:
                g1 = copy(g)
                for v in T.vertices():
                    g1.delete_vertex(v)
                for v in g1.vertices():
                    if g1.degree(v) == 0:
                        g1.delete_vertex(v)
                if g1.is_isomorphic(P3) or g1.is_isomorphic(graphs.CycleGraph(4)):
                    if ex(g,P3,6) == 0:
                        print "Found!"
                        if g.is_isomorphic(pendant(6)):
                            print "G = K_5^*(1,1,1,1,1)"
                        else:
                            print "G is not one of the claimed extremal graphs"
                        print
                        G6.append(g)
