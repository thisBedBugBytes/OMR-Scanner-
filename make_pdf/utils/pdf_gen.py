from fpdf import FPDF
from fpdf.enums import XPos, YPos
from io import BytesIO

    #create function to determine # of questions per page

sp_per_q = 287 / 31

#create function to determine # of rows per page
class PDF(FPDF):
    top_margin = 30
    bottom_margin = 5
    p_x = 200
    p_y = 297 - top_margin - bottom_margin

    def __init__(self, orientation = 'P', unit = 'mm', format = 'A4'):
        super().__init__(orientation, unit, format)

        self.add_page()
        self.set_line_width(0.2)
        self.set_font('Helvetica', '', 10)
        self.cell(14, 1, 'Name:', border = 0)


        self.ln(15)
        self.set_line_width(0.5)
        #self.rect(5, 30, self.p_x, self.p_y)
def que_no(y):

    return y // sp_per_q


def generate_pdf(q_no):
    # Initialize FPDF object
    pdf = PDF('P', 'mm', 'A4')
    pdf.set_auto_page_break(auto=True, margin=5)

   

   
    pdf.set_line_width(0.5)  # Set line width
    pdf.set_draw_color(0, 0, 0)

    hw = 100
    hl = 287 // 2

    # Get the user input
    user_input = q_no
    question_no = int(user_input)

    # Parameters for circle and spacing
    circle_radius = 2.5  # Radius of the circle
    sp = 9  # Spacing between circles
    keys = ['A','B','C', 'D' ]
    # Set font for numbers
    pdf.set_font('Helvetica', '', 10)
    question_counter = question_no
    pages = (question_no - 56) // 31

    # Initialize row counter
    rows_per_page = que_no(pdf.p_y)  # Max rows per page
    current_row = 0  # Row number
    current_col = 0
    #dimension of borders
    rect_h = pdf.p_y + 2
    rect_w = circle_radius * 16 + 23
    pdf.rect(20, 26, rect_w, rect_h)


    # Loop to draw numbers and circles
    for i in range(question_no):
        # Calculate the X and Y positions for the numbers and circles
        x = 30 if(current_col % 2 == 0) else(15 + hw)  # Horizontal position (max 4 circles per row)

            # Calculate y position (reset after 31 questions)
        y = (15 + (current_row % rows_per_page) * sp)
        if((current_col == 0 or current_col == 1)):
            y += pdf.top_margin - 5

        # Draw the number next to the circle
        pdf.text(x , y, str(i + 1) + '.')  # Adjust for spacing

        # Draw 4 circles for each question (horizontally aligned)
        for (j, c) in enumerate(keys):
            # Draw a circle inside the cell
        # Set circle outline color (black)

            # Here we simulate a circle inside a cell
            cell_width = circle_radius * 2 + 2  # Width of the cell (to fit the circle)
            cell_height = circle_radius * 2 + 2  # Height of the cell (to fit the circle)

            # Use cell() to define the space and then draw the circle
            pdf.set_line_width(0.2)
            pdf.circle(x + 10 + (j * 10), y, circle_radius, style="D")  # Draw circle inside the cell
            #pdf.cell(cell_width, cell_height, keys[j-1], new_x=XPos.RIGHT)  # Draw the cell (empty content)
            text_x = x - pdf.get_string_width(c) / 2
            text_y = y - circle_radius / 2
            pdf.text(text_x+ 10 + (j * 10), y + 1, c)

        # Move to the next line after every 4th circle
        pdf.ln(sp)

        # Increment row counter
        current_row += 1
        question_counter -= 1



        # If we reach the max number of rows per page, add a new page and reset the row counter
        if current_row >= rows_per_page:
            y = 15
            current_col += 1
            current_row = 0
            pdf.set_line_width(0.4)
            if current_col % 2 == 0 and question_counter > 0:
                pdf.add_page()


            if current_col > 1:
                pages -= 1
                rows_per_page = que_no(287)
                #check if last page

                if question_counter < 30:
                    print("Last col")
                    rect_h = ((question_counter % 30 ) * sp_per_q + 5) if (question_counter > 0) else (0)
                    rect_w = rect_w if (question_counter > 0) else 0
                    if current_col % 2 != 0:
                        print("1st col "+ str(rect_h))
                        pdf.rect(hw + 10, 5, rect_w, rect_h)
                    else:
                        print("2nd col")
                        pdf.rect(15, 5, rect_w, rect_h)
                else:
                    rect_h = 287
                    if current_col % 2 == 0:
                        pdf.rect(15, 5, rect_w, rect_h)
                    else:
                        pdf.rect(hw + 10, 5, rect_w, rect_h)

            elif current_col == 1:
            # rect_h = (question_no - question_counter) - (question_no % 28)
                pdf.rect(12 + hw, 26, rect_w, rect_h)



    pdf_output = BytesIO()
    pdf.output(pdf_output)
    pdf_output.seek(0)
    if pdf_output.getvalue():  # Check if there's data
        print("PDF generated with size:", len(pdf_output.getvalue()))
    else:
        print("PDF generation failed.")
    # Output the PDF
    return pdf_output



def generate_pdf2(q_no):
    # Initialize FPDF object
    pdf = PDF('P', 'mm', 'A4')
    pdf.set_auto_page_break(auto=True, margin=5)

   

   
    pdf.set_line_width(0.5)  # Set line width
    pdf.set_draw_color(0, 0, 0)

    hw = 100
    hl = 287 // 2

    # Get the user input
    user_input = q_no
    question_no = int(user_input)

    # Parameters for circle and spacing
    circle_radius = 2.5  # Radius of the circle
    sp = 9  # Spacing between circles
    keys = ['A','B','C', 'D' ]
    # Set font for numbers
    pdf.set_font('Helvetica', '', 10)
    question_counter = question_no
    pages = (question_no - 56) // 31

    # Initialize row counter
    rows_per_page = que_no(pdf.p_y)  # Max rows per page
    current_row = 0  # Row number
    current_col = 0
    #dimension of borders
    rect_h = pdf.p_y + 2
    rect_w = circle_radius * 16 + 23
    pdf.rect(20, 26, rect_w, rect_h)


    # Loop to draw numbers and circles
    for i in range(question_no):
        # Calculate the X and Y positions for the numbers and circles
        x = 30 if(current_col % 2 == 0) else(15 + hw)  # Horizontal position (max 4 circles per row)

            # Calculate y position (reset after 31 questions)
        y = (15 + (current_row % rows_per_page) * sp)
        if((current_col == 0 or current_col == 1)):
            y += pdf.top_margin - 5

        # Draw the number next to the circle
        pdf.text(x , y, str(i + 1) + '.')  # Adjust for spacing

        # Draw 4 circles for each question (horizontally aligned)
        for (j, c) in enumerate(keys):
            # Draw a circle inside the cell
        # Set circle outline color (black)

            # Here we simulate a circle inside a cell
            cell_width = circle_radius * 2 + 2  # Width of the cell (to fit the circle)
            cell_height = circle_radius * 2 + 2  # Height of the cell (to fit the circle)

            # Use cell() to define the space and then draw the circle
            pdf.set_line_width(0.2)
            pdf.circle(x + 10 + (j * 10), y, circle_radius, style="D")  # Draw circle inside the cell
            #pdf.cell(cell_width, cell_height, keys[j-1], new_x=XPos.RIGHT)  # Draw the cell (empty content)
            text_x = x - pdf.get_string_width(c) / 2
            text_y = y - circle_radius / 2
            pdf.text(text_x+ 10 + (j * 10), y + 1, c)

        # Move to the next line after every 4th circle
        pdf.ln(sp)

        # Increment row counter
        current_row += 1
        question_counter -= 1



        # If we reach the max number of rows per page, add a new page and reset the row counter
        if current_row >= rows_per_page:
            y = 15
            current_col += 1
            current_row = 0
            pdf.set_line_width(0.4)
            if current_col % 2 == 0 and question_counter > 0:
                pdf.add_page()


            if current_col > 1:
                pages -= 1
                rows_per_page = que_no(287)
                #check if last page

                if question_counter < 30:
                    print("Last col")
                    rect_h = ((question_counter % 30 ) * sp_per_q + 5) if (question_counter > 0) else (0)
                    rect_w = rect_w if (question_counter > 0) else 0
                    if current_col % 2 != 0:
                        print("1st col "+ str(rect_h))
                        pdf.rect(hw + 10, 5, rect_w, rect_h)
                    else:
                        print("2nd col")
                        pdf.rect(15, 5, rect_w, rect_h)
                else:
                    rect_h = 287
                    if current_col % 2 == 0:
                        pdf.rect(15, 5, rect_w, rect_h)
                    else:
                        pdf.rect(hw + 10, 5, rect_w, rect_h)

            elif current_col == 1:
            # rect_h = (question_no - question_counter) - (question_no % 28)
                pdf.rect(12 + hw, 26, rect_w, rect_h)



    pdf_output = BytesIO()
    pdf.output(pdf_output)
    pdf_output.seek(0)
    if pdf_output.getvalue():  # Check if there's data
        print("PDF generated with size:", len(pdf_output.getvalue()))
    else:
        print("PDF generation failed.")
    # Output the PDF
    return pdf