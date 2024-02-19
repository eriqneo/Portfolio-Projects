import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import pandas as pd

class DataManipulationApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Data Manipulation Tool")
        self.root.geometry("800x600")

        self.data_frame = pd.DataFrame()

        # Menu bar
        self.menu_bar = tk.Menu(root)
        self.file_menu = tk.Menu(self.menu_bar, tearoff=0)
        self.file_menu.add_command(label="Import Data", command=self.import_data)
        self.file_menu.add_command(label="Export Data", command=self.export_data)
        self.file_menu.add_separator()
        self.file_menu.add_command(label="Exit", command=root.quit)
        self.menu_bar.add_cascade(label="File", menu=self.file_menu)
        self.root.config(menu=self.menu_bar)

        # Data table
        self.data_table = ttk.Treeview(root, columns=(), show="headings")
        self.data_table.pack(fill="both", expand=True)

        # Statistics display
        self.statistics_label = tk.Label(root, text="Statistics:")
        self.statistics_label.pack()
        self.statistics_display = tk.Text(root)
        self.statistics_display.pack(fill="both", expand=True)

        # Buttons for additional functionalities
        self.shape_button = tk.Button(root, text="View Shape", command=self.view_shape)
        self.shape_button.pack()
        self.describe_button = tk.Button(root, text="View Summary", command=self.view_summary)
        self.describe_button.pack()
        self.head_button = tk.Button(root, text="View First Few Rows", command=self.view_head)
        self.head_button.pack()
        self.sum_button = tk.Button(root, text="Sum of Columns", command=self.sum_columns)
        self.sum_button.pack()
        self.count_button = tk.Button(root, text="Count Non-Null Values", command=self.count_values)
        self.count_button.pack()

    def import_data(self):
        file_path = filedialog.askopenfilename(filetypes=[("CSV Files", "*.csv"), ("Excel Files", "*.xlsx")])
        print("File path:", file_path)

        if file_path:
            try:
                if file_path.endswith('.csv'):
                    print("Reading CSV file...")
                    self.data_frame = pd.read_csv(file_path)
                elif file_path.endswith('.xlsx'):
                    print("Reading Excel file...")
                    self.data_frame = pd.read_excel(file_path)

                print("Data frame contents:")
                print(self.data_frame.head())

                self.display_data()
            except Exception as e:
                messagebox.showerror("Error", str(e))

    def export_data(self):
        file_path = filedialog.asksaveasfilename(defaultextension=".csv", filetypes=[("CSV Files", "*.csv")])
        if file_path:
            try:
                self.data_frame.to_csv(file_path, index=False)
                messagebox.showinfo("Export Successful", f"Data exported to {file_path}")
            except Exception as e:
                messagebox.showerror("Error", str(e))

    def display_data(self):
        """Updates the data table and statistics display."""
        # Clear existing data in the table
        for row in self.data_table.get_children():
            self.data_table.delete(row)

        # Insert new data into the table
        for row in self.data_frame.itertuples(index=False):
            self.data_table.insert("", "end", values=row)

        # Calculate and display statistics
        self.calculate_statistics()

    def calculate_statistics(self):
        """Calculates and displays descriptive statistics for the data."""
        if self.data_frame.empty:
            self.statistics_display.delete("1.0", tk.END)
            self.statistics_display.insert(tk.END, "No data to calculate statistics.")
            return

        stats = self.data_frame.describe().to_string(float_format='%.2f')
        self.statistics_display.delete("1.0", tk.END)
        self.statistics_display.insert(tk.END, stats)

    def view_shape(self):
        """Displays the shape of the data frame."""
        shape_str = f"Shape of the data frame: {self.data_frame.shape}"
        messagebox.showinfo("Shape", shape_str)

    def view_summary(self):
        """Displays summary statistics of the data frame."""
        summary_str = f"Summary statistics:\n{self.data_frame.describe()}"
        messagebox.showinfo("Summary", summary_str)

    def view_head(self):
        """Displays the first few rows of the data frame."""
        head_str = f"First few rows:\n{self.data_frame.head()}"
        messagebox.showinfo("First Few Rows", head_str)

    def sum_columns(self):
        """Calculates the sum of each column in the data frame."""
        if not self.data_frame.empty:
            sums = self.data_frame.sum()
            messagebox.showinfo("Sum of Columns", f"Sum of each column:\n{sums}")
        else:
            messagebox.showinfo("Sum of Columns", "No data available.")

    def count_values(self):
        """Counts the number of non-null values in each column."""
        if not self.data_frame.empty:
            counts = self.data_frame.count()
            messagebox.showinfo("Count Non-Null Values", f"Count of non-null values in each column:\n{counts}")
        else:
            messagebox.showinfo("Count Non-Null Values", "No data available.")

if __name__ == "__main__":
    root = tk.Tk()
    app = DataManipulationApp(root)
    root.mainloop()




            
