use strict;
use warnings;
use Module::Build;

my $class = Module::Build->subclass(
				    class => 'My::Builder',
				    code => q{
					      sub ACTION_build {
						  my $self = shift ;
						  $self->add_build_element('jquery_js') ;
						  $self->SUPER::ACTION_build(@_)	;			
						  # And copy all of the files 
						  #print "END OF ACTION_build!\n";
					      } 
					      sub process_jquery_js_files { 
						  my $self = shift  ; 
						  use File::Find ; 
						  my @list ; 
						  find({wanted => sub { push @list ,$File::Find::name } ,  no_chdir => 1},"lib/JQuery/jquery_js","lib/JQuery/cgi-bin");
						  for my $src (@list) { 
						      next if -d $src ; 
						      next if $src =~ /~$/ ; 
						      $self->copy_if_modified( from => $src, to_dir => 'blib') ; 
						  } 
						  #print "PROCESSED JS FILES\n" ; 
					      } 
					  }
					 );


my $builder = $class->new(
    module_name         => 'JQuery',
    license             => 'perl',
    dist_author         => 'Peter Gordon <peter@pg-consultants.com>',
    dist_abstract	=> 'A javascript interface, based on jQuery, giving simple access to Ajax and other feature from CGI',
    dist_version_from   => 'lib/JQuery.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
               'XML::Writer'  => '0.6',
               'IO::String'  => '1.0',
	       'HTML::Table' => '1.0',
               'CGI::Carp' => '1.0',	 
               'CGI::Application' => '1.0',	 
               'CSS' => '1.0',	 

		},
    add_to_cleanup      => [ 'JQuery-*' ],
);

$builder->create_build_script();