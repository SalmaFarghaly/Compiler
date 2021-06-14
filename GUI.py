from typing import Text
import PySimpleGUI as sg  
import os
foldername = '.'
filenames = '.'


sg.theme('Dark')
button_color = '#ffeda3'
text_color = "#2940d3"
selection = ('Theme 1','Theme 2','Theme 3')
width = max(map(len, selection))+1

buttons = [sg.Button("Compile",key="compile_current",button_color=(text_color, button_color))
,sg.Button("Load",key="_FILEBROWSE_",button_color=(text_color, button_color), enable_events=True, visible=False)
,sg.FileBrowse('Load',key='load',button_color=(text_color, button_color),target='_FILEBROWSE_')
,sg.Button("Save",key="_FOLDERBROWSE_",button_color=(text_color, button_color), enable_events=True, visible=False)
,sg.FolderBrowse('Save',key="save",button_color=(text_color, button_color),target='_FOLDERBROWSE_')]

layout = [ [sg.Multiline(size=(100,20), key="code",background_color='white',text_color="blue")],
            [sg.Text("Terminal",justification='center',text_color='red')],
            [sg.Multiline(size=(100,5), key="message",background_color='white',text_color="blue")],
            [buttons]]
window = sg.Window("GCC Compiler", layout, finalize=True)
#combo = window['-COMBO-']
#combo.bind("<Enter>", "ENTER-")

while True:

    event, values = window.read()
    #print("event =",event,"Values= ", values)
    
    if event == sg.WINDOW_CLOSED:
        break
    elif event =="compile_current":
        print(values)
        f = open(os.getcwd()+'\out.txt', "w")
        f.write(values['code'])
        f.close()  
        filep = os.getcwd()+'\out.txt'   
        try:
            print("file path: ",filep)
            with open(filep, 'r') as file:
                pass
            #print("gcc_clone.exe "+'\"'+filep+'\"')
            os.system("gcc_clone.exe "+'\"'+filep+'\"')
            with open('out_errors.txt', 'r') as file:
                data = file.read()
            window['message'].update(data)
        except:
            sg.popup("No file to Compile")
#
    elif event =="_FILEBROWSE_":
        with open(values['load'], 'r') as file:
            data = file.read()#.replace('\n', '')
        window['code'].update(data)
        values['save']=values['load']
        values['load'] = ''
        print(values)
    elif event == "_FOLDERBROWSE_":
        f = open(values['save']+"\out.txt", "w")
        f.write(values['code'])
        f.close()  
        values['save']+="\out.txt"
        print(values)
        

window.close()