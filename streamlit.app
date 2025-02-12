import streamlit as st
import pandas as pd
import numpy as np

# Define the dataset manually (you can load from CSV if needed)
data = {
    "Mark_2022": [79.5, 70, 60, 50, 40, 40.4],
    "Rank_2022": [1, 9, 38, 174, 502, "Qualifying"],
    "Mark_2023": [66, 60, 50, 40, 30, 28.7],
    "Rank_2023": [1, 3, 17, 82, 309, "Qualifying"],
    "Mark_2024": [79.33, 70, 60, 50, 40, 41.1],
    "Rank_2024": [1, 11, 49, 171, 450, "Qualifying"]
}

df = pd.DataFrame(data)

st.title("📊 Expected Rank Predictor")

# Ask user for marks
user_marks = st.number_input("🔢 Enter your expected marks:", min_value=0.0, max_value=100.0, step=0.1)

# Function to estimate rank
def estimate_rank(marks, marks_col, rank_col, year):
    for i in range(len(df) - 1):
        min_marks = df.iloc[i][marks_col]
        max_marks = df.iloc[i + 1][marks_col]
        min_rank = df.iloc[i][rank_col]
        max_rank = df.iloc[i + 1][rank_col]
        
        # Handling qualifying case
        if isinstance(min_rank, str) or isinstance(max_rank, str):
            if marks < max_marks:
                return f"⚠️ Qualifying mark for {year} was higher"

        # Check within range and interpolate
        if min_marks >= marks >= max_marks:
            estimated_rank = int(np.interp(marks, [max_marks, min_marks], [max_rank, min_rank]))
            return estimated_rank
    
    # If marks exceed the highest in the dataset, return the best rank
    if marks > df.iloc[0][marks_col]:
        return df.iloc[0][rank_col]
    
    # If marks are below the lowest, return qualifying message
    return f"⚠️ Qualifying mark for {year} was higher"

# Display ranks only if user has entered marks
if user_marks:
    st.subheader("📌 Expected Ranks for Your Marks")
    rank_2022 = estimate_rank(user_marks, 'Mark_2022', 'Rank_2022', '2022')
    rank_2023 = estimate_rank(user_marks, 'Mark_2023', 'Rank_2023', '2023')
    rank_2024 = estimate_rank(user_marks, 'Mark_2024', 'Rank_2024', '2024')

    st.write(f"📌 **2022 Rank:** {rank_2022}")
    st.write(f"📌 **2023 Rank:** {rank_2023}")
    st.write(f"📌 **2024 Rank:** {rank_2024}")

