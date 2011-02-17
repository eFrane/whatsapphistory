WhatsApp Chat History Beautifier
================================

This python script parses a WhatsApp Chat History (as Zip-File)
into a HTML Package.

## Howto

1.  get the WhatsApp History of a user
2.  put all the files into one folder or have a Zip-File containing all the files
3.  run
        python whatsapphistory.py <path_to_folder> [<outputdir>]

<path_to_folder> is either the path to the folder where all the files from
your emailed WhatsApp History reside or the complete path (including the filename)
to a Zip-File with the same contents.

## FAQ

### 1\. How do I obtain a WhatsApp History?

Open WhatsApp, go into Settings and scroll all the way down to "E-Mail Chat History",
select the Contact whose history you want to obtain and enter an email address. After
a short time, open your e-mail client and put all the attachments of the WhatsApp
mail into one folder or (if your email client supports this) download a Zip-Archive
containing all the attachments.

### 2\. What if the script complains about an ImportError after startup and exits?

If whatsapphistory.py exits with an error message like

        Traceback (most recent call last):
          File "whatsapphistory.py", line 1, in <module>
            from mako.template import Template
        ImportError: No module named mako.template

instantly after starting it, you most probably don't have the Mako templating system
installed or are using a wrong python binary.

Try one of these:

        pip install Mako

        easy_install Mako

or to check, where the python binary you are using looks for modules:

        python -c "import sys; print sys.path"

## License

This software is released under the terms of the GNU Affero General Public License
