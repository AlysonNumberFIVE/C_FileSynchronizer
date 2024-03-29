
# Coded by AlysonBelle

executable = synchronize

networking_directory = sources/networking/

sources_directory = sources/

handshake_directory = sources/handshaking/

objects_directory = objects/

alylibc = alylibc/

alylibc_a = lib.a

handshake_list = handshake.c \
		deserialize_transmission_buffer.c \
		file_list_linked_list_manager.c \
		gather_all_file_info.c \
		number_of_files.c \
		send_and_receive_buffer_manager.c \
		serialize_transmission_buffer.c \
		total_of_all_file_sizes.c \
		directory_linked_list_manager.c \
		resolve_file_conflicts.c

networking_list = propagate_data.c 

source_list = main.c initialize_daemon.c utils.c server.c client.c \
	user_loop_socket_monitor.c \
	file_and_timestamp_linked_list_manager.c  \
	hash.c shasumfile.c receive_handler.c sync_accept.c \
	sync_loop.c sync_update.c socket_id_list_manager.c

flags = -Wall -Wextra -pedantic -pedantic-errors

links = -lpthread

networking_object_list = $(networking_list:.c=.o)
handshake_objects_list = $(handshake_list:.c=.o)
objects_list = $(source_list:.c=.o)


alylibc_archive = $(addprefix $(alylibc), $(alylibc_a))
handshakes = $(addprefix $(handshake_directory), $(handshake_list))
networking = $(addprefix $(networking_directory), $(networking_list))
sources = $(addprefix $(sources_directory), $(source_list))
objects = $(addprefix $(objects_directory), $(objects_list) $(handshake_objects_list)	$(networking_object_list))

UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
   install_tool = brew install
   installs = fswatch
else
   install_tool = sudo apt-get install
   installs = inotify
endif


dependencies:

	$(install_tool) $(installs)

all:
	echo $(UNAME_S)
	make all -C $(alylibc)
	gcc -c $(flags) $(sources) $(handshakes) $(networking)
	gcc -o $(executable) $(objects_list) $(handshake_objects_list) $(networking_object_list) $(alylibc_archive) $(links)
	mv $(objects_list) $(handshake_objects_list) $(networking_object_list) $(objects_directory) 

clean:
	make clean -C $(alylibc)
	rm -f $(objects)

fclean:
	make fclean -C $(alylibc)
	rm -f $(executable)
	rm -f $(objects)

re: fclean all

