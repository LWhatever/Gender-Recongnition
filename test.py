# -*- coding: utf-8 -*-
import numpy as np
import pandas as pd
from sklearn.externals import joblib

from sklearn import metrics 

def nn_test_plpsu(test):
        # nn= joblib.load('save/nn.pkl')
        # scaler= joblib.load('save/scaler.pkl')
        nn= joblib.load('save/plpsu_nn.pkl')
        scaler= joblib.load('save/plpsu_scaler.pkl')
        test=np.reshape(test, (1, -1))
        test=scaler.transform(test)        
        output=nn.predict(test)[0]
        output=float(output)
        if int(output)==1 or int(output)==3:
                return float(1)
        elif int(output)==0 or int(output)==2:
                return float(0)

def nn_test_plp(test):
        # nn= joblib.load('save/nn.pkl')
        # scaler= joblib.load('save/scaler.pkl')
        nn= joblib.load('save/plp_nn.pkl')
        scaler= joblib.load('save/plp_scaler.pkl')
        test=np.reshape(test, (1, -1))
        test=scaler.transform(test)        
        output=nn.predict(test)[0]
        output=float(output)
        if int(output)==1 or int(output)==3:
                return float(1)
        elif int(output)==0 or int(output)==2:
                return float(0)

def nn_test_plp_kid(test):
        # nn= joblib.load('save/nn.pkl')
        # scaler= joblib.load('save/scaler.pkl')
        nn= joblib.load('save/plp_kid_nn.pkl')
        scaler= joblib.load('save/plp_kid_scaler.pkl')
        test=np.reshape(test, (1, -1))
        test=scaler.transform(test)        
        output=nn.predict(test)[0]
        output=float(output)
        if int(output)==1 or int(output)==3:
                return float(1)
        elif int(output)==0 or int(output)==2:
                return float(0)

def nn_test_gfcc(test):
        # nn= joblib.load('save/nn.pkl')
        # scaler= joblib.load('save/scaler.pkl')
        nn= joblib.load('save/gfcc_nn.pkl')
        scaler= joblib.load('save/gfcc_scaler.pkl')
        test=np.reshape(test, (1, -1))
        test=scaler.transform(test)        
        output=nn.predict(test)[0]
        output=float(output)
        if int(output)==1 or int(output)==3:
                return float(1)
        elif int(output)==0 or int(output)==2:
                return float(0)

