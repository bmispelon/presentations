.. include:: <s5defs.txt>

Stdlib Safari
=============

Exotic Animal Edition

*AKA "Seeking Strange Serpentine Specimens"*


About me
--------

Baptiste Mispelon (bmispelon)

I've been using python for over 5 years.

Currently doing web development with Django at `M2BPO`__.

__ http://www.m2bpo.fr


About this talk
---------------

* Builtin functions
* Little-known usage of common builtins
* Little-known modules


Part 1: Builtins
----------------

Python2 has 80 builtin functions.

Python3 has 69.

That's not a lot, especially compared to a certain scri\ **P**\ ting language
whose name s\ **H**\ all not be s\ **P**\ oken.


Builtins Table (python2)
------------------------

.. table:: :class: builtins

    =============== ============= ============== ============== ================ ==============
    ``abs``         ``complex``   ``getattr``    ``locals``     ``range``        ``super``     
    ``all``         ``delattr``   ``globals``    ``long``       ``raw_input``    ``tuple``     
    ``any``         ``dict``      ``hasattr``    ``map``        ``reduce``       ``type``      
    *.*             ``dir``       ``hash``       ``max``        ``reload``       ``unichr``    
    ``basestring``  ``divmod``    ``help``       ``memoryview`` ``repr``         ``unicode``   
    ``bin``         ``enumerate`` ``hex``        ``min``        ``reversed``     ``vars``      
    ``bool``        ``eval``      ``id``         ``next``       ``round``        ``xrange``    
    ``bytearray``   *.*           ``input``      ``object``     ``set``          ``zip``       
    *.*             ``execfile``  ``int``        ``oct``        ``setattr``      ``__import__``
    ``callable``    ``file``      ``isinstance`` ``open``       ``slice``        ``apply``     
    ``chr``         ``filter``    ``issubclass`` ``ord``        ``sorted``       ``buffer``    
    ``classmethod`` ``float``     ``iter``       ``pow``        ``staticmethod`` ``coerce``    
    ``cmp``         ``format``    ``len``        ``print``      ``str``          ``intern``    
    ``compile``     ``frozenset`` ``list``       ``property``   ``sum``                        
    =============== ============= ============== ============== ================ ==============


Builtins Table (python3)
------------------------

.. table:: :class: builtins

    =============== ============= ============== ============== ================ ==============
    ``abs``         ``complex``   ``getattr``    ``locals``     ``range``        ``super``     
    ``all``         ``delattr``   ``globals``    *.*            *.*              ``tuple``     
    ``any``         ``dict``      ``hasattr``    ``map``        *.*              ``type``      
    ``ascii``       ``dir``       ``hash``       ``max``        *.*              ``unichr``    
    *.*             ``divmod``    ``help``       ``memoryview`` ``repr``         *.*           
    ``bin``         ``enumerate`` ``hex``        ``min``        ``reversed``     ``vars``      
    ``bool``        ``eval``      ``id``         ``next``       ``round``        *.*           
    ``bytearray``   ``exec``      ``input``      ``object``     ``set``          ``zip``       
    ``bytes``       *.*           ``int``        ``oct``        ``setattr``      ``__import__``
    ``callable``    *.*           ``isinstance`` ``open``       ``slice``        *.*           
    ``chr``         ``filter``    ``issubclass`` ``ord``        ``sorted``       *.*           
    ``classmethod`` ``float``     ``iter``       ``pow``        ``staticmethod`` *.*           
    *.*             ``format``    ``len``        ``print``      ``str``          *.*           
    ``compile``     ``frozenset`` ``list``       ``property``   ``sum``                        
    =============== ============= ============== ============== ================ ==============


Short Selection
---------------

* ``dir``
* ``divmod``
* ``slice``
* ``set`` / ``frozenset``


``dir``
-------

Quick and dirty introspection.

List of all the attributes/methods of an object (as strings).


Example
-------

What are all the public attributes of this object?

.. sourcecode:: python

    obj = 'hello world'
    [attr for attr in dir(obj)
        if not attr.startswith('_')]


Example
-------

What are all the public attributes of this object?

.. sourcecode:: python

    obj = 'hello world'
    [attr for attr in dir(obj)
        if not attr.startswith('_')]
    # ['capitalize', 'casefold', 'center',
    #  'count', 'encode', 'endswith', ...]


``divmod``
----------

Given two numbers, return a pair of quotient, remainder.


Example
-------

.. sourcecode:: python

    a, b = 42, 5
    q, r = a // b, a % b
    q, r # ?


Example
-------

.. sourcecode:: python

    a, b = 42, 5
    q, r = a // b, a % b
    q, r # 8, 2


Example
-------

.. sourcecode:: python

    a, b = 42, 5
    q, r = divmod(a, b)
    q, r # 8, 2


``slice``
---------

Create slice objects.


Example
-------

.. sourcecode:: python

    s = 'abcdefghi'
    s[ :8]   # ?
    s[1:8]   # ?
    s[1:8:2] # ?


Example
-------

.. sourcecode:: python

    s = 'abcdefghi'
    s[ :8]   # 'abcdefgh'
    s[1:8]   # ?
    s[1:8:2] # ?


Example
-------

.. sourcecode:: python

    s = 'abcdefghi'
    s[ :8]   # 'abcdefgh'
    s[1:8]   # 'bcdefgh'
    s[1:8:2] # ?


Example
-------

.. sourcecode:: python

    s = 'abcdefghi'
    s[ :8]   # 'abcdefgh'
    s[1:8]   # 'bcdefgh'
    s[1:8:2] # 'bdfh'


With ``slice``
--------------

.. sourcecode:: python

    s = 'abcdefghi'
    s[ :8]   == s[slice(8)]
    s[1:8]   == s[slice(1, 8)]
    s[1:8:2] == s[slice(1, 8, 2)]


``set``
-------

Unordered collection of distinct objects.


Advantages
----------

* Behave like lists: ``iter(set)``, ``len(set)``, ``x in set``
* Elements are unique
* ``x in set`` is O(1)


Restrictions
------------

* Elements must be hashable (like keys of a dict)
* Not indexable: ``some_set[0]`` does not work.
* No order (like a dict)


Set literals
------------

Since python 2.7:

.. sourcecode:: python

    set([1, 2, 3])
    # Is the same as doing
    {1, 2, 3}


Set comprehensions
------------------

Since python 2.7 (too):

.. sourcecode:: python

    set(w.lower() for w in wordlist)
    # Is the same as doing
    {w.lower() for w in wordlist}


Operators
---------

* intersection: ``s1 & s2``
* union: ``s1 | s2``
* difference: ``s1 - s2``
* symmetric difference: ``s1 ^ s2``
* Subset/Superset: ``s1 < s2``


Examples
--------

.. sourcecode:: python

    set('abababc') # {'a', 'c', 'b'}
    {1, 2} & {2, 3}
    {1, 2} | {2, 3}
    {1, 2} - {2, 3}
    {1, 2} ^ {2, 3}
    {1, 2} < {2, 3}
    {1, 2} < {3, 2, 1}


Examples
--------

.. sourcecode:: python

    set('abababc') # {'a', 'c', 'b'}
    {1, 2} & {2, 3} # {2}
    {1, 2} | {2, 3}
    {1, 2} - {2, 3}
    {1, 2} ^ {2, 3}
    {1, 2} < {2, 3}
    {1, 2} < {3, 2, 1}


Examples
--------

.. sourcecode:: python

    set('abababc') # {'a', 'c', 'b'}
    {1, 2} & {2, 3} # {2}
    {1, 2} | {2, 3} # {1, 2, 3}
    {1, 2} - {2, 3}
    {1, 2} ^ {2, 3}
    {1, 2} < {2, 3}
    {1, 2} < {3, 2, 1}


Examples
--------

.. sourcecode:: python

    set('abababc') # {'a', 'c', 'b'}
    {1, 2} & {2, 3} # {2}
    {1, 2} | {2, 3} # {1, 2, 3}
    {1, 2} - {2, 3} # {1}
    {1, 2} ^ {2, 3}
    {1, 2} < {2, 3}
    {1, 2} < {3, 2, 1}


Examples
--------

.. sourcecode:: python

    set('abababc') # {'a', 'c', 'b'}
    {1, 2} & {2, 3} # {2}
    {1, 2} | {2, 3} # {1, 2, 3}
    {1, 2} - {2, 3} # {1}
    {1, 2} ^ {2, 3} # {1, 3}
    {1, 2} < {2, 3}
    {1, 2} < {3, 2, 1}


Examples
--------

.. sourcecode:: python

    set('abababc') # {'a', 'c', 'b'}
    {1, 2} & {2, 3} # {2}
    {1, 2} | {2, 3} # {1, 2, 3}
    {1, 2} - {2, 3} # {1}
    {1, 2} ^ {2, 3} # {1, 3}
    {1, 2} < {2, 3}    # False
    {1, 2} < {3, 2, 1}


Examples
--------

.. sourcecode:: python

    set('abababc') # {'a', 'c', 'b'}
    {1, 2} & {2, 3} # {2}
    {1, 2} | {2, 3} # {1, 2, 3}
    {1, 2} - {2, 3} # {1}
    {1, 2} ^ {2, 3} # {1, 3}
    {1, 2} < {2, 3}    # False
    {1, 2} < {3, 2, 1} # True


``frozenset``
-------------

Like a set, but immutable.


Why?
----

Making it immutable makes it hashable.

This means we can use it as the key of a dictionnary.

Or put it in another set/frozenset.


Why?
----

Making it immutable makes it hashable.

This means we can use it as the key of a dictionnary.

Or put it in another set/frozenset.

*(Yo Dawg, I heard you like sets...)*


Part 2: Builtins with a twist
-----------------------------

* ``next``'s second parameter
* ``iter``'s second parameter
* Imaginary friends


``iter``
--------

Make an *iterator* out of an *iterable*.

Iterable
    An object that can be iterated over (``for x in y``)

Iterator
    A type of iterable that can only go forward.


Example
-------

.. sourcecode:: python

    l = list('abc')
    ''.join(c.upper() for c in l) # ?


Example
-------

.. sourcecode:: python

    l = list('abc')
    ''.join(c.upper() for c in l) # 'ABC'


Example
-------

.. sourcecode:: python

    l = list('abc')
    ''.join(c.upper() for c in l) # 'ABC'
    ''.join(c.upper() for c in l) # 'ABC'


Example (2)
-----------

.. sourcecode:: python

    i = iter('abc')
    ''.join(c.upper() for c in i) # ?


Example (2)
-----------

.. sourcecode:: python

    i = iter('abc')
    ''.join(c.upper() for c in i) # 'ABC'


Example (2)
-----------

.. sourcecode:: python

    i = iter('abc')
    ''.join(c.upper() for c in i) # 'ABC'
    ''.join(c.upper() for c in i) # ?


Example (2)
-----------

.. sourcecode:: python

    i = iter('abc')
    ''.join(c.upper() for c in i) # 'ABC'
    ''.join(c.upper() for c in i) # ''


The Twist
---------

If you pass a second argument, ``iter`` behaves quite differently.

.. sourcecode:: python

    iter(callable, sentinel)


``iter(callable, sentinel)``
----------------------------

Call the first argument yielding the return value
and stopping when the sentinel value is reached
(or when the call raises ``StopIteration``).


Example
-------

.. sourcecode:: python

    fp = open('mydata.txt') as fp:
    for line in iter(fp.readline, 'STOP\n'):
        print line


Example (2)
-----------

.. sourcecode:: python

    from random import choice
    roll = lambda: choice(range(1, 7))
    list(iter(roll, 6)) # []
    list(iter(roll, 6)) # [4, 4, 1]


``ne×t``
--------

Advance an iterator and return the value.

Raise ``StopIteration`` if empty.


Example
-------

.. sourcecode:: python

    i = iter('abc')
    next(i) # ?
    next(i) # ?
    next(i) # ?
    next(i) # ?


Example
-------

.. sourcecode:: python

    i = iter('abc')
    next(i) # 'a'
    next(i) # ?
    next(i) # ?
    next(i) # ?


Example
-------

.. sourcecode:: python

    i = iter('abc')
    next(i) # 'a'
    next(i) # 'b'
    next(i) # ?
    next(i) # ?


Example
-------

.. sourcecode:: python

    i = iter('abc')
    next(i) # 'a'
    next(i) # 'b'
    next(i) # 'c'
    next(i) # ?


Example
-------

.. sourcecode:: python

    i = iter('abc')
    next(i) # 'a'
    next(i) # 'b'
    next(i) # 'c'
    next(i) # StopIteration


The Twist
---------

``next`` takes a second argument.

Similar to ``dict.get``, it's a value to return if the iterator is empty (instead of raising ``StopIteration``).


Example (part 2)
----------------

.. sourcecode:: python

    i = iter('abc')
    next(i, 'x') # 'a'
    next(i, 'x') # 'b'
    next(i, 'x') # 'c'
    next(i, 'x') # ?


Example (part 2)
----------------

.. sourcecode:: python

    i = iter('abc')
    next(i, 'x') # 'a'
    next(i, 'x') # 'b'
    next(i, 'x') # 'c'
    next(i, 'x') # 'x'


Imaginary friends
-----------------

Did you know that python has first class support for complex numbers?

.. sourcecode:: python

    a = complex(real=4, imag=1)
    b = complex(real=1, imag=2)
    a + b     # ?


Imaginary friends
-----------------

Did you know that python has first class support for complex numbers?

.. sourcecode:: python

    a = complex(real=4, imag=1)
    b = complex(real=1, imag=2)
    a + b     # complex(5, 3)


Imaginary friends
-----------------

Did you know that python has first class support for complex numbers?

.. sourcecode:: python

    a = complex(real=4, imag=1)
    b = complex(real=1, imag=2)
    a + b     # complex(5, 3)
    a + b + 1 # ?


Imaginary friends
-----------------

Did you know that python has first class support for complex numbers?

.. sourcecode:: python

    a = complex(real=4, imag=1)
    b = complex(real=1, imag=2)
    a + b     # complex(5, 3)
    a + b + 1 # complex(6, 3)


The Twist
---------

It also has imaginary number litterals:

.. sourcecode:: python

    1 + 2j # complex(1, 2)


The Twist
---------

It also has imaginary number litterals:

.. sourcecode:: python

    1 + 2j  # complex(1, 2)
    3j      # complex(0, 3)


The Twist
---------

It also has imaginary number litterals:

.. sourcecode:: python

    1 + 2j  # complex(1, 2)
    3j      # complex(0, 3)
    1j ** 2 # ?


The Twist
---------

It also has imaginary number litterals:

.. sourcecode:: python

    1 + 2j  # complex(1, 2)
    3j      # complex(0, 3)
    1j ** 2 # -1


Fun with maths
--------------

.. sourcecode:: python

    from math import e, pi
    e ** (1j * pi) # ?


Fun with maths
--------------

.. sourcecode:: python

    from math import e, pi
    e ** (1j * pi) # -1


Part 3: Exotic Stdlib Modules
-----------------------------

Python ships with more than 300 modules in its standard library.

Here's a quick tour of some of its less known corners.


``python -m FOO``
-----------------

Basically the same as doing ``python FOO.py`` where ``FOO`` is on the python path.

Executes the content of the module.


Easter eggs
-----------

``python -m this``

``python -m __hello__``

``python -m antigravity``


Utilities
---------

Some standard modules are written in a way that they can be used as standalone
programs (not just imported).

Uses the ``if __name__ == '__main__'`` trick.


Share a directory over the network?
-----------------------------------


Share a directory over the network?
-----------------------------------

.. sourcecode:: bash

    python2 -m SimpleHTTPServer
    python3 -m http.server

Browse and dowload files from the current directory (on port 8000).


Check a file for bad identation?
--------------------------------


Check a file for bad identation?
--------------------------------

.. sourcecode:: bash

    python -m tabnanny your_file.py


Print a calendar of the current year?
-------------------------------------


Print a calendar of the current year?
-------------------------------------

.. sourcecode:: bash

    python -m calendar


Print a calendar of the current year?
-------------------------------------

.. sourcecode:: bash

    python -m calendar
    python -m calendar 2014


Print a calendar of the current year?
-------------------------------------

.. sourcecode:: bash

    python -m calendar
    python -m calendar 2014 10


Encode a file in base64?
------------------------


Encode a file in base64?
------------------------

.. sourcecode:: bash

    python -m base64 some_file


Open a URL in the browser?
--------------------------


Open a URL in the browser?
--------------------------

.. sourcecode:: bash

    python -m webbrowser "http://google.hu"


Get documentation for a function?
---------------------------------


Get documentation for a function?
---------------------------------

.. sourcecode:: bash

    python -m pydoc str.find
    python -m pydoc yourmodule.yourfunction


List of functions in a file?
----------------------------


List of functions in a file?
----------------------------

.. sourcecode:: bash

    python -m pyclbr your_file.py
    python -m pyclbr modulename


List of functions in a file?
----------------------------

.. sourcecode:: bash

    python -m pyclbr your_file.py
    python -m pyclbr modulename

Safe to run on arbitrary files.


Batteries Included
------------------

An arbitrary selection of useful modules,

for use in python code.


Parsing CSV?
------------

.. sourcecode:: python
   :class: bad

    with open('file.csv') as f:
        for line in f:
            row = line.split(',')
            print row


``import csv``
--------------

.. sourcecode:: python
   :class: good

    import csv
    with open('file.csv') as f:
        for row in csv.reader(f):
            print row


Leap Years
----------

.. sourcecode:: python
   :class: bad

    def is_leap(year):
        return (year % 4) == 0


Leap Years
----------

.. sourcecode:: python
   :class: bad

    def is_leap(year):
        return (year % 4) == 0
    # Hmm... wait


Leap Years
----------

.. sourcecode:: python
   :class: bad

    def is_leap(year):
        return (year % 4) == 0 \
            and (year % 100) != 0
    # Aah, that's better


Leap Years
----------

.. sourcecode:: python
   :class: bad

    def is_leap(year):
        return (year % 4) == 0 \
            and (year % 100) != 0
    # ... or is it?


``import calendar``
-------------------

.. sourcecode:: python
   :class: good

    import calendar
    calendar.isleap(2013)


Prompting for a password
------------------------

.. sourcecode:: python
   :class: bad

    password = raw_input("Password: ")


``import getpass``
------------------

.. sourcecode:: python
   :class: good

    from getpass import getpass
    password = getpass()


Alphabet
--------

.. sourcecode:: python
   :class: bad

    s = 'abcdefghijklmnoprstuvwxyz'
    s = '0123456789'


``import string``
------------------

.. sourcecode:: python
   :class: good

    import string
    string.ascii_lowercase
    string.ascii_uppercase
    string.digits
    string.punctuation
    string.whitespace


Temporary Files
---------------

.. sourcecode:: python
   :class: bad

    from random import choice as ch
    S = 'abcdefghjklmnopqrstuvwxyz'
    name = ''.join(ch(S) for _ in range(8))
    temp = open('/tmp/%s' % name, 'w')


``import tempfile``
-------------------

.. sourcecode:: python
   :class: good

    import tempfile
    temp = tempfile.TemporaryFile()


Passing files to a program
--------------------------

.. sourcecode:: python
   :class: bad

    import sys
    for fname in sys.argv[1:]:
        f = open(fname)
        for line in f:
            process(line)


``import fileinput``
--------------------

.. sourcecode:: python
   :class: good

    import fileinput
    for line in fileinput.fileinput():
        process(line)


``import fileinput``
--------------------

.. sourcecode:: python
   :class: good

    import fileinput
    for line in fileinput.fileinput():
        process(line)
    # It even supports '-' for STDIN


Wrapping text
-------------

.. sourcecode:: python
   :class: bad

    for i in range(len(text) // 80):
        print text[i*80: (i+1)*80]


``import textwrap``
-------------------

.. sourcecode:: python
   :class: good

    import textwrap
    lines = textwrap.wrap(text, width=80)
    print '\n'.join(lines)


``import textwrap``
-------------------

.. sourcecode:: python
   :class: good

    import textwrap
    print textwrap.fill(text, width=80)


Python Keywords
---------------

.. sourcecode:: python
   :class: bad

    kw = ['class', 'for', 'if', ...]


``import keyword``
------------------

.. sourcecode:: python
   :class: good

    import keyword
    keyword.kwlist


``import keyword``
------------------

.. sourcecode:: python
   :class: good

    import keyword
    keyword.kwlist
    keyword.iskeyword('class')


Unicode
-------

.. sourcecode:: python

    print u'Csá'


Unicode
-------

.. sourcecode:: python

    print u'Csá'
    print u'Cs\xe1'


Unicode
-------

.. sourcecode:: python

    print u'Csá'
    print u'Cs\xe1'
    print u'Cs\u00e1'


Unicode
-------

.. sourcecode:: python

    print u'Csá'
    print u'Cs\xe1'
    print u'Cs\u00e1'
    print u'Cs\U000000e1'


Unicode
-------

.. sourcecode:: python

    print u'Csá'
    print u'Cs\xe1'
    print u'Cs\u00e1'
    print u'Cs\U000000e1'
    print u'Cs\N{LATIN SMALL LETTER A\
     WITH ACUTE}'


``import unicodedata``
----------------------

.. sourcecode:: python

    from unicodedata import name, lookup
    name(u'á')
        # LATIN SMALL LETTER A WITH ACUTE
    lookup('LATIN SMALL LETTER A WITH ACUTE')
        # á


Listing Files
-------------

.. sourcecode:: python
   :class: bad

    import os
    for fname in os.listdir('.'):
        if fname.endswith('.txt'):
            print fname


``import glob``
---------------

.. sourcecode:: python
   :class: good

    import glob
    for fname in glob.glob('*.txt'):
        print fname


And many more
-------------

``colorsys``,
``difflib``,
``fractions``,
``fnmatch``,
``robotparser``,
``wave``,
``shlex``,
``contextlib``,
``inspect``,
...


TLDR;
-----

Python is awesome.

Go look in your ``/usr/lib/python/``, see what you can find.


Thanks for listening!
---------------------

Questions?

Kérdes?
