|           R-type           | length |           typehint           |         Python-type         |   
| -------------------------- | ------ | ---------------------------- | --------------------------- |   
| NULL                       |        |                              | None                        |   
| logical                    |      1 |                              | boolean                     |   
| integer                    |      1 |                              | long                        |   
| integer                    |      1 | int                          | int                         |   
| numeric                    |      1 |                              | double                      |   
| character                  |      1 |                              | unicode                     |   
| character                  |      1 | string                       | string                      |   
| character                  |      1 | bytes                        | bytes                       |   
|                            |        |                              |                             |   
| logical                    |  n > 1 |                              | PythonInR.vector (boolean)  |   
| integer                    |  n > 1 |                              | PythonInR.vector (long)     |   
| integer                    |  n > 1 | int                          | PythonInR.vector (int)      |   
| numeric                    |  n > 1 |                              | PythonInR.vector (double)   |   
| character                  |  n > 1 |                              | PythonInR.vector (unicode)  |   
| character                  |  n > 1 | string                       | PythonInR.vector (string)   |   
| character                  |  n > 1 | bytes                        | PythonInR.vector (bytes)    |   
|                            |        |                              |                             |   
| logical                    |  n > 1 | list                         | list (boolean)              |   
| integer                    |  n > 1 | list                         | list (long)                 |   
| integer                    |  n > 1 | list, int                    | list (int)                  |   
| numeric                    |  n > 1 | list                         | list (double)               |   
| character                  |  n > 1 | list                         | list (unicode)              |   
| character                  |  n > 1 | list, string                 | list (string)               |   
| character                  |  n > 1 | list, bytes                  | list (bytes)                |   
|                            |        |                              |                             |   
| logical                    |  n > 1 | tuple                        | tuple (boolean)             |   
| integer                    |  n > 1 | tuple                        | tuple (long)                |   
| integer                    |  n > 1 | tuple, int                   | tuple (int)                 |   
| numeric                    |  n > 1 | tuple                        | tuple (double)              |   
| character                  |  n > 1 | tuple                        | tuple (unicode)             |   
| character                  |  n > 1 | tuple, string                | tuple (string)              |   
| character                  |  n > 1 | tuple, bytes                 | tuple (bytes)               |   
|                            |        |                              |                             |   
| logical                    |  n > 1 | numpy                        | ndarray (boolean)           |   
| integer                    |  n > 1 | numpy                        | ndarray (long)              |   
| integer                    |  n > 1 | numpy, int                   | ndarray (int)               |   
| numeric                    |  n > 1 | numpy                        | ndarray (double)            |   
| character                  |  n > 1 | numpy                        | ndarray (unicode)           |   
| character                  |  n > 1 | numpy, string                | ndarray (string)            |   
| character                  |  n > 1 | numpy, bytes                 | ndarray (bytes)             |   
|                            |        |                              |                             |   
| matrix                     |        |                              | PythonInR.matrix            |   
| matrix                     |        | numpy                        | ndarray                     |   
| matrix                     |        | cvxopt                       | cvxopt.matrix               |   
|                            |        |                              |                             |   
| arrray                     |        |                              | PythonInR.array             |   
| arrray                     |        | numpy                        | ndarray                     |   
|                            |        |                              |                             |  
| list                       |        |                              | list                        |   
| named list                 |        |                              | dict                        |   
|                            |        |                              |                             |  
| data.frame                 |        |                              | dataFrame                   |   
| data.frame                 |        | pandas                       | pandas.DataFrame            |   
|                            |        |                              |                             |   
| simple_triplet_matrix      |        |                              | simple_triplet_matrix       |   
| simple_triplet_matrix      |        | bsr                          | scipy.bsr                   |   
| simple_triplet_matrix      |        | coo                          | scipy.coo                   |   
| simple_triplet_matrix      |        | csc                          | scipy.csc                   |   
| simple_triplet_matrix      |        | csr                          | scipy.csr                   |   
| simple_triplet_matrix      |        | dense                        | scipy.dense                 |   
| simple_triplet_matrix      |        | dia                          | scipy.dia                   |   
| simple_triplet_matrix      |        | lil                          | scipy.lil                   |   
| simple_triplet_matrix      |        | cvxopt                       | cvxopt.spmatrix             |   
|                            |        |                              |                             |  
| Tree (NLP)                 |        |                              | nltk.tree                   |  