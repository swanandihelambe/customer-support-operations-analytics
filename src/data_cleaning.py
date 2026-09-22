import pandas as pd
import numpy as np


# ============================================================
# Customer Support Operations Analytics
# Data Cleaning & Feature Engineering
# ============================================================

INPUT_PATH = "../data/raw/synthetic_it_support_tickets.csv"
OUTPUT_PATH = "../data/cleaned/customer_support_cleaned.csv"


def load_data(path):
    """Load the raw customer support ticket dataset."""
    return pd.read_csv(path)


def clean_data(df):
    """Clean and prepare the dataset for analysis."""

    # Convert timestamp to datetime
    df["created_at"] = pd.to_datetime(df["created_at"])

    # Represent missing regions explicitly
    df["region"] = df["region"].fillna("Unknown")

    # Create time-based analytical features
    df["year"] = df["created_at"].dt.year
    df["month"] = df["created_at"].dt.month
    df["quarter"] = df["created_at"].dt.quarter
    df["day_of_week"] = df["created_at"].dt.day_name()
    df["hour"] = df["created_at"].dt.hour

    # Operational status indicators
    df["is_resolved"] = df["status"].isin(
        ["resolved", "closed_no_action"]
    ).astype(int)

    df["is_backlog"] = df["status"].isin(
        ["open", "in_progress", "on_hold"]
    ).astype(int)

    # Resolution time bands
    bins = [-np.inf, 24, 48, 72, np.inf]
    labels = [
        "Under 1 day",
        "1–2 days",
        "2–3 days",
        "Over 3 days"
    ]

    df["resolution_time_band"] = pd.cut(
        df["resolution_time_hours"],
        bins=bins,
        labels=labels,
        right=False
    )

    return df


def main():
    df = load_data(INPUT_PATH)

    print(f"Raw dataset shape: {df.shape}")

    df = clean_data(df)

    df.to_csv(OUTPUT_PATH, index=False)

    print(f"Cleaned dataset shape: {df.shape}")
    print(f"Cleaned dataset saved to: {OUTPUT_PATH}")


if __name__ == "__main__":
    main()