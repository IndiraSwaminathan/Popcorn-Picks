# Build a recommendation engine that recommends movies to users.
# Item Based Collaborative Filter recommendation system
library(recommenderlab)
library(ggplot2)                       
library(data.table)
library(reshape2)
# Retrieve and display data
#setwd("/Users/arpitabhattacharya/Desktop/Warwick /Internship/Github uploads/Movie recommendation - R/IMDB-Dataset")
movie_data <- read.csv("movies.csv",stringsAsFactors=FALSE)
rating_data <- read.csv("ratings.csv")
str(movie_data) #Structure of a dataframe
# Overview the summary 
summary(movie_data)
head(movie_data)
summary(rating_data)
head(rating_data)
# Data pre-processing
# Creating a one-hot encoding to create a matrix that comprises of corresponding genres for each of the films.
movie_genre <- as.data.frame(movie_data$genres, stringsAsFactors=FALSE)
library(data.table)
#Selecting first column of movie_genre and type.convert stores the values in appropriate datatype
movie_genre2 <- as.data.frame(tstrsplit(movie_genre[,1], '[|]', 
                                        type.convert=TRUE), 
                              stringsAsFactors=FALSE) 
#Setting column names using a vector
colnames(movie_genre2) <- c(1:10)
list_genre <- c("Action", "Adventure", "Animation", "Children", 
                "Comedy", "Crime","Documentary", "Drama", "Fantasy",
                "Film-Noir", "Horror", "Musical", "Mystery","Romance",
                "Sci-Fi", "Thriller", "War", "Western")
# matrix of dimensions 10,330 rows and 18 columns, filled with zeros.
#Creating a binary matrix for a film with the genres
genre_mat1 <- matrix(0,10330,18)
genre_mat1[1,] <- list_genre
colnames(genre_mat1) <- list_genre
for (index in 1:nrow(movie_genre2)) {
  for (col in 1:ncol(movie_genre2)) {
    gen_col = which(genre_mat1[1,] == movie_genre2[index,col]) #returns index of genre_mat[1,] where comparison is true
    genre_mat1[index+1,gen_col] <- 1
  }
}

#Converting genre_mat1 to genre_mat2 with integer values instead of chr values
genre_mat2 <- as.data.frame(genre_mat1[-1,], stringsAsFactors=FALSE) #remove first row, which was the genre list
for (col in 1:ncol(genre_mat2)) {
  genre_mat2[,col] <- as.integer(genre_mat2[,col]) #convert from characters to integers
} 
print("Structure of Genre_mat2")
str(genre_mat2)

# Creating a ‘search matrix’ - searching films by specifying the genre
SearchMatrix <- cbind(movie_data[,1:2], genre_mat2[])
print("Head of SearchMatrix")
print(head(SearchMatrix))

#reshaping long-data to wide-data format using dcast
ratingMatrix <- dcast(rating_data, userId~movieId, value.var = "rating", na.rm=FALSE)
ratingMatrix <- as.matrix(ratingMatrix[,-1]) #remove userIds

#Convert rating matrix into a recommenderlab sparse matrix(data structure is essential for building recommendation systems using collaborative filtering)
ratingMatrix <- as(ratingMatrix, "realRatingMatrix")
ratingMatrix

# Overview some important parameters for building recommendation systems for movies
#retrieves all the available recommendation algorithms 
recommendation_model <- recommenderRegistry$get_entries(dataType = "realRatingMatrix")
#names of the different recommendation algorithms 
print(names(recommendation_model))
#a list of descriptions explaining the purpose and functionality of each recommendation algorithm.
print(lapply(recommendation_model, "[[", "description"))

# Implementing a single model in the R project – Item Based Collaborative Filtering
recommendation_model$IBCF_realRatingMatrix$parameters #checking parameters for this model

# Collaborative Filtering involves suggesting movies to the users that are based on collecting preferences from many other users.

# With the help of recommenderlab, we can compute similarities between users
similarity_mat <- similarity(ratingMatrix[1:4, ],
                             method = "cosine",
                             which = "users")
as.matrix(similarity_mat)
image(as.matrix(similarity_mat), main = "User's Similarities")

# Portray the similarity that is shared between the films
movie_similarity <- similarity(ratingMatrix[, 1:4], method =
                                 "cosine", which = "items")
as.matrix(movie_similarity)
image(as.matrix(movie_similarity), main = "Movies similarity")

#Extracting data from realrating matrix to standard R format for computation purpose
rating_values <- as.vector(ratingMatrix@data)
unique(rating_values) # extracting unique ratings
Table_of_Ratings <- table(rating_values) # creating a count of movie ratings
print(Table_of_Ratings)


# Most viewed movies visualization
library(ggplot2)
movie_views <- colCounts(ratingMatrix) # count views for each movie
table_views <- data.frame(movie = names(movie_views),
                          views = movie_views) # create dataframe of views
table_views <- table_views[order(table_views$views,
                                 decreasing = TRUE), ] # sort by number of views
table_views$title <- NA
for (index in 1:10325){
  table_views[index,3] <- as.character(subset(movie_data,
                                              movie_data$movieId == table_views[index,1])$title)
}
table_views[1:6,]

# Visualize a bar plot for the total number of views of the top films
ggplot(table_views[1:6, ], aes(x = title, y = views)) +
  geom_bar(stat="identity", fill = 'steelblue') +
  geom_text(aes(label=views), vjust=-0.3, size=3.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Total Views of the Top Films")

# Heatmap of Movie Ratings
# Visualize a heatmap of the movie ratings
image(ratingMatrix[1:20, 1:20], axes = FALSE, main = "Heatmap of the first 25 rows and 25 columns")

# Data Preparation
# Filter the rating matrix for users and items with more than 50 ratings
movie_ratings <- ratingMatrix[rowCounts(ratingMatrix) > 50,
                              colCounts(ratingMatrix) > 50]
print(movie_ratings)

# describing matrix of relevant users
minimum_movies<- quantile(rowCounts(movie_ratings), 0.95)
minimum_users <- quantile(colCounts(movie_ratings), 0.95)
image(movie_ratings[rowCounts(movie_ratings) > minimum_movies,
                    colCounts(movie_ratings) > minimum_users],
      main = "Heatmap of the top users and movies")

# Visualizing the distribution of the average ratings per user
average_ratings <- rowMeans(movie_ratings)
qplot(average_ratings, fill=I("steelblue"), col=I("red")) +
  ggtitle("Distribution of the average rating per user")

# Data Normalization
normalized_ratings <- normalize(movie_ratings)
sum(rowMeans(normalized_ratings) > 0.00001)
image(normalized_ratings[rowCounts(normalized_ratings) > minimum_movies,
                         colCounts(normalized_ratings) > minimum_users],
      main = "Normalized Ratings of the Top Users and Movies")

# Data Binarization
binary_minimum_movies <- quantile(rowCounts(movie_ratings), 0.95)
binary_minimum_users <- quantile(colCounts(movie_ratings), 0.95)
good_rated_films <- binarize(movie_ratings, minRating = 3)
image(good_rated_films[rowCounts(movie_ratings) > binary_minimum_movies,
                       colCounts(movie_ratings) > binary_minimum_users],
      main = "Binarised Matrix: Heatmap of the top users and movies")


# Collaborative Filtering System

# Splitting the dataset into 80% training set and 20% test set
sampled_data<- sample(x = c(TRUE, FALSE),
                      size = nrow(movie_ratings),
                      replace = TRUE,
                      prob = c(0.8, 0.2))
training_data <- movie_ratings[sampled_data, ]
testing_data <- movie_ratings[!sampled_data, ]

# Building the Recommendation System
#specifies that you're interested in recommendation algorithms that can handle real-valued ratings
recommendation_system <- recommenderRegistry$get_entries(dataType ="realRatingMatrix")
recommendation_system$IBCF_realRatingMatrix$parameters #checking default parameters of the model
# k indicates the number of similar items to consider when making recommendations
recommen_model <- Recommender(data = training_data,
                              method = "IBCF",
                              parameter = list(k = 30))
recommen_model
class(recommen_model)

# Exploring the data science recommendation system model
model_info <- getModel(recommen_model)
class(model_info$sim) #class of similarity matrix
dim(model_info$sim) #dimensions of similarity matrix
top_items <- 20
# Heatmap of similarity scores between top 20 items
image(model_info$sim[1:top_items, 1:top_items],
      main = "Similarity Scores Heatmap of the first 20 rows and columns")

# Visualize sum of rows and columns with the similarity of the objects above 0
sum_rows <- rowSums(model_info$sim > 0)
user_distribution <- table(sum_rows)  # Get counts for each unique count
print(user_distribution)  # Display the distribution (447 users have rated 30 movies positively)

sum_cols <- colSums(model_info$sim > 0)
qplot(sum_cols, fill=I("steelblue"), col=I("red"))+ ggtitle("Distribution of the column count")

# the number of items to recommend to each user
top_recommendations <- 10 
predicted_recommendations <- predict(object = recommen_model,
                                     newdata = testing_data,
                                     n = top_recommendations)
#Returns a list in recommender lab format with recommendations for the test set users
predicted_recommendations

#Recommendations for the first user
recommendations_list <- as(predicted_recommendations, "list")
recommendations_list[[1]]  # Get recommendations for the first user

# recommendation for the first user with movie names
user1 <- predicted_recommendations@items[[1]] 
movies_user1 <- predicted_recommendations@itemLabels[user1]
movies_user_list <- movies_user1
for (index in 1:10){
  movies_user_list[index] <- as.character(subset(movie_data,
                                             movie_data$movieId == movies_user1[index])$title)
}
movies_user_list


# matrix with the recommendations for each user
#items contain the indices of the recommendations, sapply iterates through the recommended item indices for each us
#Convert the recommended item indices into actual movie IDs (from column names of movie_ratings)
recommendation_matrix <- sapply(predicted_recommendations@items,
                                function(x){ as.integer(colnames(movie_ratings)[x]) }) 
print(recommendation_matrix[,1:4]) #rows = Recommendations and columns = user-ids

# Distribution of the Number of Items for IBCF
#Counts how many times each movie is recommended across all the users, factor helps to make distinct values out of the counts
number_of_items <- factor(table(recommendation_matrix))
chart_title <- "Distribution of the Number of Items for IBCF"
qplot(number_of_items, fill=I("steelblue"), col=I("red")) + ggtitle(chart_title)

number_of_items_sorted <- sort(number_of_items, decreasing = TRUE)
number_of_items_top <- head(number_of_items_sorted, n = 4)
print(number_of_items_top)
table_top <- data.frame(as.integer(names(number_of_items_top)),
                        number_of_items_top)
for(i in 1:4) {
  table_top[i,1] <- as.character(subset(movie_data,
                                        movie_data$movieId == table_top[i,1])$title)
}

colnames(table_top) <- c("Movie Title", "No. of Items")
head(table_top)


