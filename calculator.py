import tkinter as tk
from tkinter import *

# Function to update the expression in the input field
def press(key):
    current_text = equation.get()
    equation.set(current_text + str(key))

# Function to evaluate the final expression
def equal_press():
    try:
        result = str(eval(equation.get()))
        equation.set(result)
    except Exception as e:
        messagebox.showerror("Error", "Invalid Input")

# Function to clear the input field
def clear():
    equation.set("")

# Main GUI application
root = tk.Tk()
root.title("Calculator")

# Set window size
root.geometry("300x400")

# Variable to store the input expression
equation = tk.StringVar()

# Entry widget for displaying the input and output
input_field = tk.Entry(root, textvariable=equation, font=('Arial', 18), justify='right', bd=10, insertwidth=4)
input_field.grid(row=0, columnspan=4, ipadx=8, ipady=8)

# Calculator buttons
buttons = [
    ('7', 1, 0), ('8', 1, 1), ('9', 1, 2), ('/', 1, 3),
    ('4', 2, 0), ('5', 2, 1), ('6', 2, 2), ('*', 2, 3),
    ('1', 3, 0), ('2', 3, 1), ('3', 3, 2), ('-', 3, 3),
    ('0', 4, 0), ('.', 4, 1), ('=', 4, 2), ('+', 4, 3),
]

# Create buttons and place them on the grid
for (text, row, col) in buttons:
    if text == '=':
        button = tk.Button(root, text=text, height=3, width=9, font=('Arial', 18),
                           command=equal_press)
    else:
        button = tk.Button(root, text=text, height=3, width=9, font=('Arial', 18),
                           command=lambda t=text: press(t))
    button.grid(row=row, column=col)

# Clear button
clear_button = tk.Button(root, text='C', height=3, width=9, font=('Arial', 18), command=clear)
clear_button.grid(row=4, column=2)

# Start the main event loop
root.mainloop()

