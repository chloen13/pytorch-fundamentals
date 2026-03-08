import logging
import numpy as np
from scipy import stats
import pandas as pd
import os

logger = logging.getLogger(__name__)

def regression():
    a = float(os.environ["XX"])
    print(f"read environment variable XX as: {a}")
    df = pd.read_csv("regression_input.csv")

    x = df["x"].to_numpy()
    y = df["y"].to_numpy()

    result = stats.linregress(x, y)

    return a * result.slope + result.intercept


if __name__ == "__main__":
    print(f"result: {regression()}")

    logger.info("Azure App Job has started.")
    logger.info("Azure App Job has completed.")
