import numpy as np
import pandas as pd
import requests
import math
from config import IEX_CLOUD_API_TOKEN
from scipy.stats import percentileofscore as score
import xlsxwriter


stocks = pd.read_csv('sp_500_stocks.csv')



symbol = 'AAPL'
api_url = f'https://sandbox.iexapis.com/stable/stock/{symbol}/stats?token={IEX_CLOUD_API_TOKEN}'
data = requests.get(api_url).json()
#print(data)


#data['year1ChangePercent']


def chunks(lst, n):
    """Yield successive n-sized chunks from lst."""
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

symbol_groups = list(chunks(stocks['Ticker'], 100))
symbol_strings = []
for i in range(0, len(symbol_groups)):
    symbol_strings.append(','.join(symbol_groups[i]))
my_columns = ['Ticker', 'Price', 'One-Year Price Return', 'Number of Shares to Buy']


final_dataframe = pd.DataFrame(columns = my_columns)
for symbol_string in symbol_strings:
    batch_api_call_url = f'https://sandbox.iexapis.com/stable/stock/market/batch?symbols={symbol_string}&types=stats,price&token={IEX_CLOUD_API_TOKEN}'
    data = requests.get(batch_api_call_url).json()
    for symbol in symbol_string.split(','):
        final_dataframe = final_dataframe.append(
            pd.Series(
                [
                    symbol,
                    data[symbol]['price'],
                    data[symbol]['stats']['year1ChangePercent'],
                    'N/A'

                ],
                index=my_columns),
            ignore_index=True
        )
print(final_dataframe)


final_dataframe.sort_values('One-Year Price Return', ascending = False, inplace = True)
final_dataframe = final_dataframe[:50]
final_dataframe.reset_index(inplace = True)
final_dataframe


def portfolio_input():
    global portfolio_size
    portfolio_size = input('Enter the size of your portfolio:')

    try:
        float(portfolio_size)
    except ValueError:
        print('That is not a number, please try again.')
        portfolio_size = input('Enter the portfolio size:')

portfolio_input()
#print('Your portfolio size is ' + portfolio_size)


position_size = float(portfolio_size)/len(final_dataframe.index)
for i in range(0, len(final_dataframe)):
    final_dataframe.loc[i, 'Number of Shares to Buy'] = math.floor(position_size/final_dataframe.loc[i, 'Price'])
final_dataframe


hqm_columns = [
    'Ticker',
    'Price',
    'Number of Shares to Buy',
    'One-Year Price Return',
    'One-Year Return Percentile',
    'Six-Months Price Return',
    'Six-Months Return Percentile',
    'Three-Months Price Return',
    'Three-Months Return Percentile',
    'One-Month Price Return',
    'One-Month Return Percentile',
    'HQM Score'
]
hqm_dataframe = pd.DataFrame(columns = hqm_columns)


for symbol_string in symbol_strings:
    batch_api_call_url = f'https://sandbox.iexapis.com/stable/stock/market/batch?symbols={symbol_string}&types=stats,price&token={IEX_CLOUD_API_TOKEN}'
    data = requests.get(batch_api_call_url).json()
    for symbol in symbol_string.split(','):
        hqm_dataframe = hqm_dataframe.append(
        pd.Series(
        [
            symbol,
            data[symbol]['price'],
            'N/A',
            data[symbol]['stats']['year1ChangePercent'],
            'N/A',
            data[symbol]['stats']['month6ChangePercent'],
            'N/A',
            data[symbol]['stats']['month3ChangePercent'],
            'N/A',
            data[symbol]['stats']['month1ChangePercent'],
            'N/A',
            'N/A'
        ],
        index = hqm_columns),
        ignore_index = True
        )
#print(hqm_dataframe)

time_periods = [
    'One-Year',
    'Six-Months',
    'Three-Months',
    'One-Month'
]
for row in hqm_dataframe.index:
    for time_period in time_periods:

        change_col = f'{time_period} Price Return'
        percentile_col = f'{time_period} Return Percentile'
        if hqm_dataframe.loc[row, change_col] == None:
            hqm_dataframe.loc[row, change_col] = 0.0

for row in hqm_dataframe.index:
    for time_period in time_periods:
        change_col = f'{time_period} Price Return'
        percentile_col = f'{time_period} Return Percentile'

        hqm_dataframe.loc[row, percentile_col] = score(hqm_dataframe[change_col], hqm_dataframe.loc[row, change_col])/100

#print(hqm_dataframe)

from statistics import mean

for row in hqm_dataframe.index:
    momentum_percentiles = []
    for time_period in time_periods:
        momentum_percentiles.append(hqm_dataframe.loc[row, f'{time_period} Return Percentile'])
    hqm_dataframe.loc[row, 'HQM Score'] = mean(momentum_percentiles)

#print(hqm_dataframe)


hqm_dataframe.sort_values('HQM Score', ascending = False, inplace = True)
hqm_dataframe = hqm_dataframe[:50]
hqm_dataframe.reset_index(inplace = True, drop = True)
#print(hqm_dataframe)


portfolio_input()


position_size = float(portfolio_size)/len(hqm_dataframe.index)
for i in hqm_dataframe.index:
    hqm_dataframe.loc[i, 'Number of Shares to Buy'] = math.floor(position_size/hqm_dataframe.loc[i, 'Price'])
#print(hqm_dataframe)


writer = pd.ExcelWriter('momentum_strategy.xlsx', engine = 'xlsxwriter')
hqm_dataframe.to_excel(writer, 'Momentum Strategy' , index = False)


background_color = '#0a0a23'
font_color = '#ffffff'

string_template = writer.book.add_format(
        {
            'font_color': font_color,
            'bg_color': background_color,
            'border': 1
        }
    )

dollar_template = writer.book.add_format(
        {
            'num_format':'$0.00',
            'font_color': font_color,
            'bg_color': background_color,
            'border': 1
        }
    )

integer_template = writer.book.add_format(
        {
            'num_format':'0',
            'font_color': font_color,
            'bg_color': background_color,
            'border': 1
        }
    )

percent_template = writer.book.add_format(
        {
            'num_format':'0.0%',
            'font_color': font_color,
            'bg_color': background_color,
            'border': 1
        }
    )


writer.sheets['Momentum Strategy'].write('A1', 'Ticker', string_template)
writer.sheets['Momentum Strategy'].write('B1', 'Price', dollar_template)
writer.sheets['Momentum Strategy'].write('C1', 'Number of Shares to Buy', integer_template)
writer.sheets['Momentum Strategy'].write('D1', 'One-Year Price Return', percent_template)
writer.sheets['Momentum Strategy'].write('E1', 'One-Year Return Percentile', percent_template)
writer.sheets['Momentum Strategy'].write('F1', 'Six-Months Price Return', percent_template)
writer.sheets['Momentum Strategy'].write('G1', 'Six-Months Return Percentile', percent_template)
writer.sheets['Momentum Strategy'].write('H1', 'Three-Months Price Return', percent_template)
writer.sheets['Momentum Strategy'].write('I1', 'Three-Months Return Percentile', percent_template)
writer.sheets['Momentum Strategy'].write('J1', 'One-Month Price Return', percent_template)
writer.sheets['Momentum Strategy'].write('K1', 'One-Month Return Percentile', percent_template)
writer.sheets['Momentum Strategy'].write('L1', 'HQM Score', percent_template)

column_formats = {
    'A': ['Ticker', string_template],
    'B': ['Price', dollar_template],
    'C': ['Number of Shares to Buy', integer_template],
    'D': ['One-Year Price Return', percent_template],
    'E': ['One-Year Return Percentile', percent_template],
    'F': ['Six-Months Price Return', percent_template],
    'G': ['Six-Months Return Percentile', percent_template],
    'H': ['Three-Months Price Return', percent_template],
    'I': ['Three-Months Return Percentile', percent_template],
    'J': ['One-Month Price Return', percent_template],
    'K': ['One-Month Return Percentile', percent_template],
    'L': ['HQM Score', percent_template]
}
for column in column_formats.keys():
    writer.sheets['Momentum Strategy'].set_column(f'{column}:{column}', 30, column_formats[column][1])
    writer.sheets['Momentum Strategy'].write(f'{column}1',column_formats[column][0], column_formats[column][1])


writer.save()







