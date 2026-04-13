import streamlit as st
import pickle
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Load model
model = pickle.load(open("../models/delivery_model.pkl", "rb"))

# Title
st.title("🚚 Delivery Time Prediction System")

st.markdown("### Enter Order Details")

# Inputs
product_price = st.number_input("Product Price", min_value=0.0, value=100.0)
shipping_cost = st.number_input("Shipping Cost", min_value=0.0, value=20.0)

order_month = st.slider("Order Month", 1, 12, 1)
order_weekday = st.slider("Order Weekday (0=Mon, 6=Sun)", 0, 6, 0)

# Derived Feature
price_shipping_ratio = product_price / (shipping_cost if shipping_cost != 0 else 1)

# Predict Button
if st.button("Predict Delivery Time"):

    # Create input dataframe
    input_data = pd.DataFrame([{
        'product_price': product_price,
        'shipping_cost': shipping_cost,
        'order_month': order_month,
        'order_weekday': order_weekday,
        'price_shipping_ratio': price_shipping_ratio
    }])

    # Prediction
    prediction = model.predict(input_data)[0]

    # Show result
    st.success(f"📦 Estimated Delivery Time: {round(prediction,2)} days")

    # -------- Visualization --------
    st.markdown("### 📊 Prediction Trend Visualization")

    # Create variation values
    values = [prediction, prediction + 2, prediction - 1]

    fig, ax = plt.subplots()
    ax.plot(values, marker='o')

    ax.set_title("Delivery Time Trend")
    ax.set_ylabel("Days")
    ax.set_xlabel("Scenario")
    ax.set_xticks([0, 1, 2])
    ax.set_xticklabels(["Base", "High Delay", "Low Delay"])

    st.pyplot(fig)

# Divider
st.markdown("---")

# Model Info
st.markdown("### 📈 Model Information")
st.write("MAE: ~5 days")
st.write("R² Score: ~0.25")

# Insights
st.markdown("### 💡 Insights")
st.info("""
- Shipping cost strongly impacts delivery time  
- Price-to-shipping ratio is an important factor  
- Seasonal trends (month) affect performance  
""")