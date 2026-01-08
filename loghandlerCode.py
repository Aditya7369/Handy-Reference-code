#======================================================================
import logging

# Set up logging to output to a file and the console
script_dir = os.path.dirname(os.path.abspath(__file__))
log_file_path = os.path.join(script_dir, "MylogFile.log")
logging.basicConfig(filename=log_file_path, level=logging.DEBUG,
                    format='%(asctime)s - %(levelname)s - %(message)s')

# Create a console handler and set its level to INFO
console = logging.StreamHandler()
console.setLevel(logging.INFO)

# Create a formatter and set the formatter for the console handler
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
console.setFormatter(formatter)

# Add the console handler to the root logger
logging.getLogger('').addHandler(console)

# Log some messages
logging.debug('This is a debug message')
logging.info('This is an info message')
logging.warning('This is a warning message')
logging.error('This is an error message')
logging.critical('This is a critical message')
#======================================================================

