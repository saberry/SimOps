flow_data <- data.frame(from = c(1,1,1,2,2,3,4,4,5,6), 
                        to = c(2,3,4,4,7,5,5,6,7,7), 
                        ID = 1:10, 
                        cost = c(3,1,7,2,6,10,1,1,4,4))

all_nodes <- c(flow_data$from, flow_data$to) |> 
  unique()

node_flow_complete <- matrix(0, ncol = nrow(flow_data), 
                             nrow = length(all_nodes), 
                             dimnames = list(all_nodes, 
                                             flow_data$ID))

for(i in all_nodes) {
  input_node <- flow_data$ID[flow_data$to == i]
  
  output_node <- flow_data$ID[flow_data$from == i]
  
  node_flow_complete[rownames(node_flow_complete)  == i, 
                     colnames(node_flow_complete) %in% input_node] <- 1
  
  node_flow_complete[rownames(node_flow_complete) == i, 
                     colnames(node_flow_complete) %in% output_node] <- -1
  
}

node_flow_complete

dimnames(node_flow_complete) <- list(paste0("node_", all_nodes), 
               paste0("from_", flow_data$from, 
                      "_to_", flow_data$to))

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
