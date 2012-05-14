import numpy as np
from scipy.cluster.vq import vq
import munkres # from http://pypi.python.org/pypi/munkres/ (tested with 1.0.5.4)

def get_summed_inner_distance( codebook, data ):
    """calculate per-centroid sums of inner cluster distances"""
    code, dist = vq( data, codebook)
    k = len(codebook)
    sumd =  np.empty( (k,), dtype=np.float )
    count = np.empty( (k,), dtype=np.int )
    for i in range(k):
        cond = code==i
        sumd[i] = np.sum(dist[cond])
        count[i] = np.sum( cond )
    return sumd, count

def test_summed_inner_distance():
    data = [[1,0],
            [-1,0],
            [0,1],

            [9,10],
            [10,11],
            [10,9],
            [20,10],

            ]
    codebook = [[0,0],
                [10,10]]
    result, count = \
            get_summed_inner_distance( np.array(codebook), np.array(data) )
    assert my_allclose( count, [3, 4] )
    assert my_allclose( result, [3.0, 13] )

def my_allclose(a,b):
    a = np.array(a)
    b = np.array(b)
    if a.shape==b.shape:
        return np.allclose(a,b)
    else:
        return False

def match_centroids(all_codebooks):

    num_codebooks, num_clusters, num_features = all_codebooks.shape

    min_sum_cost = np.inf
    max_sum_cost = -np.inf
    best_costs = None

    for i in range(num_codebooks):
        all_costs = get_matching_costs( all_codebooks, i )
        all_costs = all_costs**2 # Braun et al work on squared distances
        this_sum_cost = np.sum(all_costs)
        if this_sum_cost < min_sum_cost:
            min_cost_idx = i
            best_costs = all_costs
            min_sum_cost = this_sum_cost
        if this_sum_cost > max_sum_cost:
            max_cost_idx = i
            max_sum_cost = this_sum_cost

    best_centroids = all_codebooks[min_cost_idx]

    normalized_costs = best_costs/(num_clusters * num_features)
    mean_instability = np.mean( normalized_costs )
    std_instability = np.std( normalized_costs )

    result = dict(
        best_centroids = best_centroids,
        min_cost_idx = min_cost_idx,
        max_cost_idx = max_cost_idx,
        normalized_costs = normalized_costs,
        mean_instability = mean_instability,
        std_instability = std_instability,
        )
    return result

def test_match_centroids():
    all_codebooks = get_sample_codebooks()
    results = match_centroids( all_codebooks )

def get_matching_costs( all_codebooks, i ):
    assert all_codebooks.ndim == 3
    this_codebook = all_codebooks[i]

    costs = []
    for i_test,other_codebook in enumerate(all_codebooks):
        if i==i_test:
            continue
        cost_table = distance_table(this_codebook, other_codebook)
        cost = minimum_cost(cost_table)
        costs.append(cost)
    costs = np.array(costs)
    return costs

def test_get_matching_costs():
    all_codebooks = get_sample_codebooks()
    actual = get_matching_costs( all_codebooks, 0 )
    for ai in actual:
        assert my_allclose( ai, 1.0 )

def distance_table( A, B ):
     assert A.shape == B.shape
     n = len(A)
     dist = np.zeros((n,n),dtype=np.float)
     for i in range(n):
         for j in range(n):
             dist[i,j] = np.sqrt(np.sum((A[i]-B[j])**2))
     return dist

def minimum_cost(in_matrix):
    """use Hungarian algorithm to find minimum cost"""
    if 1:
        # Munkres works on list of lists. (?!)
        matrix = []
        for row in in_matrix:
            matrix.append( list(row) )
    m = munkres.Munkres()
    indexes = m.compute(matrix)

    total = 0
    for row, column in indexes:
        value = matrix[row][column]
        total += value
    return total

def test_minimum_cost():
    input = [[1,2,3],
             [3,3,3],
             [3,3,2]]
    expected = 6
    actual = minimum_cost( input )
    assert actual==expected

def get_quality( codebook, data ):
    outer_dists = get_smallest_outer_distances( codebook )

    # Braun et al use squared outer distances in their quality metric
    squared_outers = outer_dists**2

    summed_inner_distances, num_cluster_members = \
                            get_summed_inner_distance( codebook, data )
    inner_distances = summed_inner_distances / num_cluster_members

    all_quality = squared_outers / inner_distances
    return all_quality

def get_smallest_outer_distances( codebook ):
    outer_distances = []
    for this_centroid in codebook:
        # XXX This does 2x the number of calculations necessary...
        between_cluster_distances = np.sqrt(np.sum( (codebook - this_centroid)**2, axis=1 ))
        idxs = np.argsort(between_cluster_distances)
        outer_distance = between_cluster_distances[idxs[1]] # lowest is this code itself and thus zero. take second.
        outer_distances.append(outer_distance)
    outer_distances = np.array(outer_distances)
    return outer_distances

def test_outer_distances():
    codebook = [[0,0],
                [0,1],
                [0,2],
                [1.0001,0],
                ]
    result = get_smallest_outer_distances( np.array(codebook) )
    assert my_allclose( result, [1.0, 1.0, 1.0, 1.0001] )

def get_sample_codebooks():
    """prepare some sample codebooks for testing"""
    all_codebooks = [

        # # this codebook is exactly 1.0 distance from the others
        [[0,0,0],
         [1,1,1]],

        [[0,0,0],
         [1,1,2]],

        [[0,0,1],
         [1,1,1]],

        [[0,0,-1],
         [1,1,1]],

        # force new ordering
        [[1,1,1],
         [0,1,0]],
        ]
    all_codebooks = np.array( all_codebooks, dtype=np.float )
    return all_codebooks
