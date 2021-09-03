cvec <- c(var1_2 = 3, 
          var1_3 = 1, 
          var1_4 = 7, 
          var2_4 = 2, 
          var2_7 = 6, 
          var3_5 = 10, 
          var4_5 = 1, 
          var4_6 = 1, 
          var5_7 = 4, 
          var6_7 = 4)

amat <- rbind(nodeS = c(1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
              node2 = c(1, 0, 0, -1, -1, 0, 0, 0, 0, 0), 
              node3 = c(0, 1, 0, 0, 0, -1, 0, 0, 0, 0), 
              node4 = c(0, 0, 1, 1, 0, 0, -1, -1, 0, 0), 
              node5 = c(0, 0, 0, 0, 0, 1, 1, 0, -1, 0), 
              node6 = c(0, 0, 0, 0, 0, 0, 0, 1, 0, -1), 
              nodeT = c(0, 0, 0, 0, -1, 0, 0, 0, -1, -1))

colnames(amat) <- names(cvec)

amat

bvec <- c(1, rep(0, 5), -1)

constraints <- rep("==", 7)

test <- lpSolve::lp("min", cvec, amat, constraints, bvec)

test

names(test$solution) <- names(cvec)

test$solution

edgelist <- data.frame(
  from = c(1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 7, 8),
  to = c(2, 3, 4, 5, 6, 4, 5, 6, 7, 8, 7, 8, 7, 8, 9, 9),
  ID = seq(1, 16, 1),
  capacity = c(20, 30, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99),
  cost = c(0, 0, 1, 2, 3, 4, 3, 2, 3, 2, 3, 4, 5, 6, 0, 0))
