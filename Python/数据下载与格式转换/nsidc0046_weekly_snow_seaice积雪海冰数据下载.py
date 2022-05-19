import time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import StaleElementReferenceException


def login(driver,username,password):
    element = WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.NAME, "username")))
    elem = driver.find_element_by_name("username")
    elem.clear()
    elem.send_keys(username)

    elem = driver.find_element_by_name("password")
    elem.clear()
    elem.send_keys(password)

    elem.send_keys(Keys.RETURN)


def download(driver):
    element = WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.ID, "indexlist")))
    files = element.find_elements_by_partial_link_text('EASE2_N25km')
    print("%s files in total" % str(len(files)))
    for ii in files:
        try:
            ii.click()
        except StaleElementReferenceException as e:
            driver.refresh()
            time.sleep(10)
            ii.click()


if __name__ == "__main__":
    url = "https://daacdata.apps.nsidc.org/pub/DATASETS/nsidc0046_weekly_snow_seaice/"
    username = "qqfraphael"
    password = "qweqweQQF123"

    driver = webdriver.Chrome()
    driver.get(url)
    login(driver, username, password)

    url = "https://daacdata.apps.nsidc.org/pub/DATASETS/nsidc0046_weekly_snow_seaice/data/"
    driver.get(url)

    download(driver)
    
    #driver.close()
