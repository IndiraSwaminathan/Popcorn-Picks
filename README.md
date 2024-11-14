# Popcorn-Picks

## Movie Recommendation System: Project using R and Machine learning
### Aim of Project
This R-based machine learning project focuses on building a movie recommendation engine using Item-Based Collaborative Filtering. The project aims to create a practical understanding of recommendation systems while applying data science and machine learning skills in a real-world context. By developing this personalized movie suggestion tool, I gained valuable hands-on experience in implementing advanced analytics techniques for predictive modeling and user-centric content delivery.

Dataset used
I have used the MovieLens Dataset. That data I have used consists of 105339 ratings in the ratings.csv file, applied over 10329 movies in the movies.csv.

Essential Libraries
recommenderlab, ggplot2, data.table and reshape2.

Data Pre-processing
In this movie recommendation project, I processed data from movies.csv and ratings.csv files, noting that both userId and movieId were integer columns. To enhance the usability of genre information in the movie_data dataframe, I implemented a one-hot encoding technique, creating a comprehensive genre matrix for each film.

Subsequently, I developed a search matrix to facilitate easy genre-based film queries. This matrix accommodates movies with multiple genres, improving search functionality.

To optimize the recommendation system's performance, I converted the genre matrix into a sparse matrix format, specifically a realRatingMatrix class. This conversion is crucial for the recommenderlab package to efficiently process ratings data.

Finally, I analyzed key parameters that offer various options for constructing movie recommendation systems. These parameters provide insights into the dataset's characteristics, such as the number of movies, unique genres, and the sparsity of the genre matrix, which are essential for fine-tuning the recommendation algorithm.

Collaborative Filtering - Exploring similar data
In this project, I implemented Collaborative Filtering, a technique that generates movie recommendations based on collective user preferences. This approach operates on the principle that users with similar tastes will likely enjoy similar content. For instance, if users A and B both have a penchant for action films, the system will suggest movies watched by B to A, and vice versa.

The core of this method lies in establishing similarity relationships between users. To achieve this, I leveraged the recommenderlab package, which offers various similarity metrics. I employed multiple operators, including cosine, Pearson correlation, and Jaccard index, to compute these user similarities.

By utilizing these diverse similarity measures, the system can identify patterns in user preferences more accurately, leading to more refined and personalized movie recommendations. This approach allows the recommendation engine to tap into the collective wisdom of the user base, enhancing the relevance and diversity of suggested films for each individual user.

Visualization: Similarity in data
I visualized the similarity between the users as explained in the above section as well as the similarity shared between the films.
Visualization: Most viewed movies
In this section of the machine learning project, I explored the most viewed movies in the dataset. Before this, I counted the number of views in a film and organized them in a table that would group them in descending order. I visualized the total number of views of the top films as a bar plot.
From the visualization, it could be observed that 'Pulp Fiction' is the most watched film followed by 'Forrest Gump'.
Visualization: Heatmap of Movie Ratings
Now, in this data science project of Recommendation system, I visualized a heatmap of the movie ratings. This heatmap will contain first 25 rows and 25 columns.
Data Preparation
This is conducted in three steps:
1.	Selecting useful data
2.	Normalizing data
3.	Binarizing the data
4.	
Data Selection: Through this I visualized the top users and movies through a heatmap. Then I visualized the distribution of the average ratings per user.

Data Normalization: In the case of some users, there can be high ratings or low ratings provided to all of the watched films. This will act as a bias while implementing the model. In order to remove this, I normalized the data. Normalization is a data preparation procedure to standardize the numerical values in a column to a common scale value. This is done in such a way that there is no distortion in the range of values. Normalization transforms the average value of our ratings column to 0. I then plotted a heatmap that portrays our normalized ratings.

Data Binarization: In the final step of the data preparation, in this data science project, I 
binarized the data. Binarizing the data means that we have two discrete values 1 and 0, which will allow the recommendation system to work more efficiently. I defined a matrix that will consist of 1 if the rating is above 3 and otherwise it will be 0.

Collaborative Filtering System
In this phase, I developed an Item-Based Collaborative Filtering System. This approach identifies item similarities based on user ratings. The algorithm constructs a similar-items table by analyzing customer purchase patterns, which then feeds into the recommendation system.
The item similarity is determined through the following steps:
1.	For each item i1 in the catalog bought by customer C
2.	For each item i2 also bought by customer C
3.	Record that C purchased both i1 and i2
4.	Calculate similarity between i1 and i2
I implemented this system using an 80/20 train-test split of the dataset. 

In building the recommendation system, I explored key parameters of the Item-Based Collaborative Filter. The default parameter 'k' (set to 30) specifies the number of most similar items to identify and store for each item. This approach enables the system to generate personalized recommendations based on item similarities derived from collective user behavior.

Exploring data science recommendation system model
Using the getModel() function, I retrieved the recommen_model. I then found the class and dimensions of the similarity matrix, that is, contained within model_info. Finally, I generated a heatmap, that will contain the top 20 items and visualize the similarity shared between them.
In the next step of the ML project, I carried out the sum of rows and columns with the similarity of the objects above 0. I visualized the sum of columns through a distribution.

Building Recommender System on dataset using R
I created a top_recommendations variable which I initialized to 10, specifying the number of films to each user. I then used the predict() function that identified similar items and ranked them appropriately. Here, each rating is used as a weight. Each weight is multiplied with related similarities. Finally, I added everything in the end.
