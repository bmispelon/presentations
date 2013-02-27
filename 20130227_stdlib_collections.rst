.. include:: <s5defs.txt>

Rediscovering the stdlib
========================

The collections module

.. sourcecode:: python

    from collections import (
        deque, defaultdict, namedtuple,
        OrderedDict, Counter
    )


About me
--------

Baptiste Mispelon (bmispelon)

I've been using python for over 5 years.

Currently doing web development with django at `M2BPO`__.

__ http://www.m2bpo.fr

About this presentation
-----------------------

No advanced python knowledge required.

Lots of small code examples.

Available online.


Introduction
------------

Python has "batteries included" philosophy,


Introduction
------------

Python has "batteries included" philosophy,

but they are easy to miss if you don't know about them.


What is this talk about?
------------------------

The :navy:`collections` module.

5 specialized container datatypes.

ABC (not presented today).


1: collections.deque
--------------------


1: collections.deque
--------------------

List-like container with fast appends and pops on either end.

Introduced in python 2.4.

Short for "doubled-ended queue".


Time Complexity
---------------
.. table::

    ===========    ====    =====
    Operation      list    deque
    ===========    ====    =====
    append                  
    pop (right)             
    prepend                 
    pop (left)              
    ===========    ====    =====


Time Complexity
---------------
.. table::

    ===========    ====    =====
    Operation      list    deque
    ===========    ====    =====
    append         O(1)     
    pop (right)             
    prepend                 
    pop (left)              
    ===========    ====    =====


Time Complexity
---------------
.. table::

    ===========    ====    =====
    Operation      list    deque
    ===========    ====    =====
    append         O(1)     
    pop (right)    O(1)     
    prepend                 
    pop (left)              
    ===========    ====    =====


Time Complexity
---------------
.. table::

    ===========    ====    =====
    Operation      list    deque
    ===========    ====    =====
    append         O(1)     
    pop (right)    O(1)     
    prepend        O(n)     
    pop (left)              
    ===========    ====    =====


Time Complexity
---------------
.. table::

    ===========    ====    =====
    Operation      list    deque
    ===========    ====    =====
    append         O(1)     
    pop (right)    O(1)     
    prepend        O(n)     
    pop (left)     O(n)     
    ===========    ====    =====


Time Complexity
---------------
.. table::

    ===========    ====    =====
    Operation      list    deque
    ===========    ====    =====
    append         O(1)    O(1)
    pop (right)    O(1)    O(1)
    prepend        O(n)    O(1)
    pop (left)     O(n)    O(1)
    ===========    ====    =====


Initialization
--------------
.. sourcecode:: python

    deque(iterable, maxlen=None)

Both parameters are optional.

Iterable: list, str, dict, generator, ...

Initialization
--------------
.. sourcecode:: python

    deque() # ?

Initialization
--------------
.. sourcecode:: python

    deque() # deque([])

Initialization
--------------
.. sourcecode:: python

    deque() # deque([])
    deque('abc') # ?

Initialization
--------------
.. sourcecode:: python

    deque() # deque([])
    deque('abc') # deque(['a', 'b', 'c'])

Initialization
--------------
.. sourcecode:: python

    deque() # deque([])
    deque('abc') # deque(['a', 'b', 'c'])
    deque(xrange(1000, 0, -1), maxlen=3)
    # ?

Initialization
--------------
.. sourcecode:: python

    deque() # deque([])
    deque('abc') # deque(['a', 'b', 'c'])
    deque(xrange(1000, 0, -1), maxlen=3)
    # deque([3, 2, 1], maxlen=3)


Practical Example
-----------------

Print the last 20 lines of a file.

.. sourcecode:: bash

    $ tail -n 20 some_file.txt


Approach 1: Naive
---------------
.. sourcecode:: python

    with open('some_file.txt') as f:
        last = list(f)[-20:] ###
    print "\n".join(last)


Approach 2: More Robust
---------------------
.. sourcecode:: python

    last = []
    with open('some_file.txt') as f:
        for line in f:
            last.append(line)
            if len(last) > 20:
                last.pop(0) ###
    print "\n".join(last)


Approach 3: deque
---------------
.. sourcecode:: python

    with open('some_file.txt') as f:
        last = deque(f, maxlen=20) ###
    print "\n".join(last)


2: collections.defaultdict
--------------------------


2: collections.defaultdict
--------------------------

Dict subclass that calls a factory function to supply missing values.

Introduced in python 2.5.


Initialization
--------------
.. sourcecode:: python

    # defaultdict(factory, *a, **kw)
    defaultdict(f)
    defaultdict(f, {'foo': 'bar'})
    defaultdict(f, [('foo', 'bar')])
    defaultdict(f, foo='bar')


What's a factory?
-----------------

Any callable without required arguments:

* functions (named or anonymous)
* classes
* instance methods


Factory examples:
-----------------
.. class:: borderless

    =========    =========
    bool       
    int        
    float      
    complex    
    str        
    list       
    dict       
    =========    =========


Factory examples:
-----------------
.. class:: borderless

    =========    =========
    bool()       ``False``
    int          
    float        
    complex      
    str          
    list         
    dict         
    =========    =========


Factory examples:
-----------------
.. class:: borderless

    =========    =========
    bool()       ``False``
    int()        ``0``
    float        
    complex      
    str          
    list         
    dict         
    =========    =========


Factory examples:
-----------------
.. class:: borderless

    =========    =========
    bool()       ``False``
    int()        ``0``
    float()      ``0.0``
    complex      
    str          
    list         
    dict         
    =========    =========


Factory examples:
-----------------
.. class:: borderless

    =========    =========
    bool()       ``False``
    int()        ``0``
    float()      ``0.0``
    complex()    ``0j``
    str          
    list         
    dict         
    =========    =========


Factory examples:
-----------------
.. class:: borderless

    =========    =========
    bool()       ``False``
    int()        ``0``
    float()      ``0.0``
    complex()    ``0j``
    str()        ``''``
    list         
    dict         
    =========    =========


Factory examples:
-----------------
.. class:: borderless

    =========    =========
    bool()       ``False``
    int()        ``0``
    float()      ``0.0``
    complex()    ``0j``
    str()        ``''``
    list()       ``[]``
    dict         
    =========    =========


Factory examples:
-----------------
.. class:: borderless

    =========    =========
    bool()       ``False``
    int()        ``0``
    float()      ``0.0``
    complex()    ``0j``
    str()        ``''``
    list()       ``[]``
    dict()       ``{}``
    =========    =========


Missing Keys
------------
.. sourcecode:: python

    # Regular dict:
    rd = dict(foo='bar')
    rd['foo']     # ?


Missing Keys
------------
.. sourcecode:: python

    # Regular dict:
    rd = dict(foo='bar')
    rd['foo']     # 'bar'


Missing Keys
------------
.. sourcecode:: python

    # Regular dict:
    rd = dict(foo='bar')
    rd['foo']     # 'bar'
    rd['missing'] # ?


Missing Keys
------------
.. sourcecode:: python

    # Regular dict:
    rd = dict(foo='bar')
    rd['foo']     # 'bar'
    rd['missing'] # KeyError


Missing Keys
------------
.. sourcecode:: python

    factory = lambda: 'X'
    dd = defaultdict(factory, foo='bar')
    dd['foo']     # ?


Missing Keys
------------
.. sourcecode:: python

    factory = lambda: 'X'
    dd = defaultdict(factory, foo='bar')
    dd['foo']     # 'bar'


Missing Keys
------------
.. sourcecode:: python

    factory = lambda: 'X'
    dd = defaultdict(factory, foo='bar')
    dd['foo']     # 'bar'
    dd['missing'] # ?


Missing Keys
------------
.. sourcecode:: python

    factory = lambda: 'X'
    dd = defaultdict(factory, foo='bar')
    dd['foo']     # 'bar'
    dd['missing'] # 'X'


Practical Example
-----------------

Given a list of payments (date, amount),

we want to get a mapping of {date: [amounts]}


Approach 1: naive
---------------
.. sourcecode:: python

    d = {}
    for date, amount in L:
        if date not in L:
            d[date] = []
        d[date].append(amount)


Approach 2: Improved
------------------
.. sourcecode:: python

    d = {}
    for date, amount in L:
        l = d.setdefault(date, [])
        l.append(amount)


Approach 3: defaultdict
---------------------
.. sourcecode:: python

    d = defaultdict(list)
    for date, amount in L:
        d[date].append(amount)


3: collections.namedtuple
-------------------------


3: collections.namedtuple
-------------------------

Factory function for creating tuple subclasses with named fields.

Introduced in python 2.6.


What is a named tuple?
----------------------

It's a subclass of tuple whose attributes can also be accessed by name
(not just by position).

It uses as much memory as a regular tuple.

Like a tuple, it's immutable.


Initialization
--------------
.. sourcecode:: python

    # cls = namedtuple(name, fields)


Initialization
--------------
.. sourcecode:: python

    # cls = namedtuple(name, fields)
    namedtuple('Point', ['x', 'y', 'z'])


Initialization
--------------
.. sourcecode:: python

    # cls = namedtuple(name, fields)
    namedtuple('Point', ['x', 'y', 'z'])
    namedtuple('Point', 'x y z')


Initialization
--------------
.. sourcecode:: python

    # cls = namedtuple(name, fields)
    namedtuple('Point', ['x', 'y', 'z'])
    namedtuple('Point', 'x y z')
    namedtuple('Point', 'x,y,z')


Initialization
--------------
.. sourcecode:: python

    # cls = namedtuple(name, fields)
    namedtuple('Point', ['x', 'y', 'z'])
    namedtuple('Point', 'x y z')
    namedtuple('Point', 'x,y,z')
    # Creates **classes**,
    #     not **instances**.


Creation
--------
.. sourcecode:: python

    Point = namedtuple('Point', 'x y z')


Creation
--------
.. sourcecode:: python

    Point = namedtuple('Point', 'x y z')


Creation
--------
.. sourcecode:: python

    Point = namedtuple('Point', 'x y z')
    p = Point(23, 10, 85)


Creation
--------
.. sourcecode:: python

    Point = namedtuple('Point', 'x y z')
    p = Point(23, 10, 85)
    p = Point(x=23, y=10, z=85)


Creation
--------
.. sourcecode:: python

    Point = namedtuple('Point', 'x y z')
    p = Point(23, 10, 85)
    p = Point(x=23, y=10, z=85)
    p = Point(y=10, x=23, z=85)


Accessing Fields
----------------
.. sourcecode:: python

    p = Point(x=23, y=10, z=85)


Accessing Fields
----------------
.. sourcecode:: python

    p = Point(x=23, y=10, z=85)
    p[0] # ?


Accessing Fields
----------------
.. sourcecode:: python

    p = Point(x=23, y=10, z=85)
    p[0] # 23


Accessing Fields
----------------
.. sourcecode:: python

    p = Point(x=23, y=10, z=85)
    p[0] # 23
    p.z  # ?


Accessing Fields
----------------
.. sourcecode:: python

    p = Point(x=23, y=10, z=85)
    p[0] # 23
    p.z  # 85


Attributes And Methods
----------------------
.. sourcecode:: python

    p = Point(x=23, y=10, z=85)
    p._fields # ?


Attributes And Methods
----------------------
.. sourcecode:: python

    p = Point(x=23, y=10, z=85)
    p._fields # ['x', 'y', 'z']


Attributes And Methods
----------------------
.. sourcecode:: python

    p1 = Point(x=23, y=10, z=85)


Attributes And Methods
----------------------
.. sourcecode:: python

    p1 = Point(x=23, y=10, z=85)
    p2 = p1._replace(z=56)


Attributes And Methods
----------------------
.. sourcecode:: python

    p1 = Point(x=23, y=10, z=85)
    p2 = p1._replace(z=56)
    tuple(p2) # ?


Attributes And Methods
----------------------
.. sourcecode:: python

    p1 = Point(x=23, y=10, z=85)
    p2 = p1._replace(z=56)
    tuple(p2) # (23, 10, 56)


Attributes And Methods
----------------------
.. sourcecode:: python

    p = Point(x=23, y=10, z=85)
    p._asdict()
    # ?


Attributes And Methods
----------------------
.. sourcecode:: python

    p = Point(x=23, y=10, z=85)
    p._asdict()
    # {'x': 23, 'y': 10, 'z': 85}


Attributes And Methods
----------------------
.. sourcecode:: python

    p = Point(x=23, y=10, z=85)
    p._asdict()
    # {'x': 23, 'y': 10, 'z': 85}
    # Actually an OrderedDict instance


4: collections.OrderedDict
--------------------------


4: collections.OrderedDict
--------------------------

Dict subclass that remembers the order entries were added.

Introduced in python 2.7.


Initialization
--------------

Identical to dict.

.. sourcecode:: python

    OrderedDict(mapping)
    OrderedDict(iterable)
    OrderedDict(**kwargs)


dict Has No Order
-----------------
.. sourcecode:: python

    d = {}
    for char in 'abc':
        d[char] = None
    print ''.join(d) # ?


dict Has No Order
-----------------
.. sourcecode:: python

    d = {}
    for char in 'abc':
        d[char] = None
    print ''.join(d) # 'acb'


dict Has No Order
-----------------
.. sourcecode:: python

    d = {}
    for char in 'abc':
        d[char] = None
    print ''.join(d) # 'acb'
    # Actually,
    # it depends on python's version.


dict Has No Order
-----------------
.. sourcecode:: python

    d = {}
    for char in 'abc':
        d[char] = None
    print ''.join(d) # 'acb'
    # Actually,
    # it depends on python's version.
    # And it's also affected by -R flag.


But ...
-------

Order is consistent between two iterations
if no items have been added or deleted.

.. sourcecode:: python

    zip(d.keys(), d.values())
    # Same as d.items()


Shortcut (fromkeys)
-------------------
.. sourcecode:: python

    d = {}
    for char in 'abc':
        d[char] = None


Shortcut (fromkeys)
-------------------
.. sourcecode:: python

    d = {}
    for char in 'abc':
        d[char] = None
    # Can be written as:
    d = dict.fromkeys('abc')


Bringing Back Order
-------------------

OrderDict are ordered by insertion order:

.. sourcecode:: python

    d = OrderedDict.fromkeys('abc')
    ''.join(d) # ?


Bringing Back Order
-------------------

OrderDict are ordered by insertion order:

.. sourcecode:: python

    d = OrderedDict.fromkeys('abc')
    ''.join(d) # 'abc'


Keys are still unique!
----------------------
.. sourcecode:: python

    d = OrderedDict.fromkeys('abcda')
    ''.join(d) # ?


Keys are still unique!
----------------------
.. sourcecode:: python

    d = OrderedDict.fromkeys('abcda')
    ''.join(d) # 'bcda'


Comparisons
-----------
.. sourcecode:: python

    od1 = OrderedDict.fromkeys('abc')
    od2 = OrderedDict.fromkeys('cba')
    rd1 = dict.fromkeys('abc')
    rd2 = dict.fromkeys('cba')
    
    rd1 == rd2 # ?


Comparisons
-----------
.. sourcecode:: python

    od1 = OrderedDict.fromkeys('abc')
    od2 = OrderedDict.fromkeys('cba')
    rd1 = dict.fromkeys('abc')
    rd2 = dict.fromkeys('cba')
    
    rd1 == rd2 # True


Comparisons
-----------
.. sourcecode:: python

    od1 = OrderedDict.fromkeys('abc')
    od2 = OrderedDict.fromkeys('cba')
    rd1 = dict.fromkeys('abc')
    rd2 = dict.fromkeys('cba')
    
    rd1 == rd2 # True
    od1 == od2 # ?


Comparisons
-----------
.. sourcecode:: python

    od1 = OrderedDict.fromkeys('abc')
    od2 = OrderedDict.fromkeys('cba')
    rd1 = dict.fromkeys('abc')
    rd2 = dict.fromkeys('cba')
    
    rd1 == rd2 # True
    od1 == od2 # False


Comparisons
-----------
.. sourcecode:: python

    od1 = OrderedDict.fromkeys('abc')
    od2 = OrderedDict.fromkeys('cba')
    rd1 = dict.fromkeys('abc')
    rd2 = dict.fromkeys('cba')
    
    rd1 == rd2 # True
    od1 == od2 # False
    od1 == rd2 # ?


Comparisons
-----------
.. sourcecode:: python

    od1 = OrderedDict.fromkeys('abc')
    od2 = OrderedDict.fromkeys('cba')
    rd1 = dict.fromkeys('abc')
    rd2 = dict.fromkeys('cba')
    
    rd1 == rd2 # True
    od1 == od2 # False
    od1 == rd2 # True


5: collections.Counter
----------------------


5: collections.Counter
----------------------

Dict subclass for counting hashable objects.

Introduced in python 2.7.


5: collections.Counter
----------------------

Basically a ``defaultdict(int)``.

With some useful methods for counting stuff.


Initialization
--------------

.. sourcecode:: python

    Counter(iterable)

Iterable: list, str, dict, generator, ...


Counting Characters
-------------------
.. sourcecode:: python

    # First approach, with a plain dict:
    counter = {}
    for letter in 'ababac':
        if letter not in counter:
            counter[letter] = 0
        counter[letter] += 1
    counter['a'] # 3


Counting Characters
-------------------
.. sourcecode:: python

    # Third approach, with a defaultdict
    counter = defaultdict(int)
    for letter in 'ababac':
        counter[letter] += 1
    counter['a'] # 3


Counting Characters
-------------------
.. sourcecode:: python

    # Finally, with a Counter
    counter = Counter('ababac')
    counter['a'] # 3


Counter Is A dict!
------------------
.. sourcecode:: python

    counter = Counter('aaabbc')
    counter['a'] # ?


Counter Is A dict!
------------------
.. sourcecode:: python

    counter = Counter('aaabbc')
    counter['a'] # 3


Counter Is A dict!
------------------
.. sourcecode:: python

    counter = Counter('aaabbc')
    counter['a'] # 3
    counter['d'] # ?


Counter Is A dict!
------------------
.. sourcecode:: python

    counter = Counter('aaabbc')
    counter['a'] # 3
    counter['d'] # 0


Counter Is A dict!
------------------
.. sourcecode:: python

    counter = Counter('aaabbc')
    sum(counter.values()) # ?


Counter Is A dict!
------------------
.. sourcecode:: python

    counter = Counter('aaabbc')
    sum(counter.values()) # 6
    # Total number of elements


Counter Is A dict!
------------------
.. sourcecode:: python

    counter = Counter('aaabbc')
    len(counter) # ?


Counter Is A dict!
------------------
.. sourcecode:: python

    counter = Counter('aaabbc')
    len(counter) # 3
    # Total number of unique elements:


Counter Is A dict!
------------------
.. sourcecode:: python

    counter = Counter('aaabbc')
    counter.keys()
    # ?


Counter Is A dict!
------------------
.. sourcecode:: python

    counter = Counter('aaabbc')
    counter.keys()
    # ['a', 'b', 'c']
    # List of unique elements


Counter.elements()
----------------------
.. sourcecode:: python

    # List elements, with repetition
    c = Counter('ababac')
    c.elements()
    # ?


Counter.elements()
----------------------
.. sourcecode:: python

    # List elements, with repetition
    c = Counter('ababac')
    c.elements()
    # ['a', 'a', 'a', 'b', 'b', 'c']


Counter.most_common()
----------------------
.. sourcecode:: python

    # List (element, count)
    c = Counter('aaabbc')
    c.most_common()
    # ?


Counter.most_common()
----------------------
.. sourcecode:: python

    # List (element, count)
    c = Counter('aaabbc')
    c.most_common()
    # [('a', 3), ('b', 2), ('c', 1)]


Counter.most_common(N)
----------------------
.. sourcecode:: python

    c = Counter('aaabbc')
    c.most_common(2)
    # ?


Counter.most_common(N)
----------------------
.. sourcecode:: python

    c = Counter('aaabbc')
    c.most_common(2)
    # [('a', 3), ('b', 2)]


Counter.update()
----------------
.. sourcecode:: python

    # Add elements
    c = Counter('aaabb')
    c.update(a=2, b=1)
    c # ?


Counter.update()
----------------
.. sourcecode:: python

    # Add elements
    c = Counter('aaabb')
    c.update(a=2, b=1)
    c # Counter({'a': 5, 'b': 3})


Counter.substract()
-------------------
.. sourcecode:: python

    # Substract elements
    c = Counter('aaabb')
    c.substract(a=2, b=1)
    c # ?


Counter.substract()
-------------------
.. sourcecode:: python

    # Substract elements
    c = Counter('aaabb')
    c.substract(a=2, b=1)
    c # Counter({'a': 1, 'b': 1})


Arithmetic Operations
---------------------
.. sourcecode:: python

    c1 = Counter('aaaabb')
    c2 = Counter('aabbb')
    c1 + c2 # ?


Arithmetic Operations
---------------------
.. sourcecode:: python

    c1 = Counter('aaaabb')
    c2 = Counter('aabbb')
    c1 + c2 # Counter({'a': 6, 'b': 5})


Arithmetic Operations
---------------------
.. sourcecode:: python

    c1 = Counter('aaaabb')
    c2 = Counter('aabbb')
    c1 + c2 # Counter({'a': 6, 'b': 5})
    c1 - c2 # ?


Arithmetic Operations
---------------------
.. sourcecode:: python

    c1 = Counter('aaaabb')
    c2 = Counter('aabbb')
    c1 + c2 # Counter({'a': 6, 'b': 5})
    c1 - c2 # Counter({'a': 2})


Arithmetic Operations
---------------------
.. sourcecode:: python

    c1 = Counter('aaaabb')
    c2 = Counter('aabbb')
    c1 + c2 # Counter({'a': 6, 'b': 5})
    c1 - c2 # Counter({'a': 2})
    c1 & c2 # ?


Arithmetic Operations
---------------------
.. sourcecode:: python

    c1 = Counter('aaaabb')
    c2 = Counter('aabbb')
    c1 + c2 # Counter({'a': 6, 'b': 5})
    c1 - c2 # Counter({'a': 2})
    c1 & c2 # Counter({'a': 2, 'b': 2})


Arithmetic Operations
---------------------
.. sourcecode:: python

    c1 = Counter('aaaabb')
    c2 = Counter('aabbb')
    c1 + c2 # Counter({'a': 6, 'b': 5})
    c1 - c2 # Counter({'a': 2})
    c1 & c2 # Counter({'a': 2, 'b': 2})
    c1 | c2 # ?


Arithmetic Operations
---------------------
.. sourcecode:: python

    c1 = Counter('aaaabb')
    c2 = Counter('aabbb')
    c1 + c2 # Counter({'a': 6, 'b': 5})
    c1 - c2 # Counter({'a': 2})
    c1 & c2 # Counter({'a': 2, 'b': 2})
    c1 | c2 # Counter({'a': 4, 'b': 3})


Conclusion (TL;DL)
------------------

* **deque**: list with fast operations on both sides;
* **defaultdict**: dict with default values;
* **namedtuple**: tuple with named attributes;
* **OrderedDict**: ordered dict;
* **Counter**: counts things.


Questions?
----------

.. image:: qr.svg
   :class: qrcode

* bmispelon@gmail.com
* `github.com/bmispelon`__
* twitter: `@bmispelon`__
* IRC: bmispelon on Freenode (#python, #django)

__ https://github.com/bmispelon/presentations
__ https://twitter.com/bmispelon

Bonus: Recipes
--------------


Formatting With Defaults
------------------------
.. sourcecode:: python

    d = dict(y='yes', no='no')
    '%(y)s %(n)s' % d
    # ?


Formatting With Defaults
------------------------
.. sourcecode:: python

    d = dict(y='yes', n='no')
    '%(y)s %(n)s' % d
    # 'yes no'


Formatting With Defaults
------------------------
.. sourcecode:: python

    d = dict(y='yes')
    '%(y)s %(n)s' % d
    # ?


Formatting With Defaults
------------------------
.. sourcecode:: python

    d = dict(y='yes')
    '%(y)s %(n)s' % d
    # KeyError: 'n'


Formatting With Defaults
------------------------
.. sourcecode:: python

    factory = lambda: 'no'
    d = defaultdict(factory, y='yes')
    '%(y)s %(n)s' % d
    # ?


Formatting With Defaults
------------------------
.. sourcecode:: python

    factory = lambda: 'no'
    d = defaultdict(factory, y='yes')
    '%(y)s %(n)s' % d
    # 'yes no'


Auto-vivifying Tree
-------------------
.. sourcecode:: python

    # don't try this at home!
    def factory():
        return defaultdict(factory)
    d = defaultdict(factory)
    
    d['a']['b']['c'] = 42


Counting Letters
----------------
.. sourcecode:: python

    s = 'a,b.a8a?b'
    Counter(c for c in s
            if c.isalpha())
    # ?


Counting Letters
----------------
.. sourcecode:: python

    s = 'a,b.a8a?b'
    Counter(c for c in s
            if c.isalpha())
    # Counter({'a': 3, 'b': 2})


Counting Letters (CI)
---------------------
.. sourcecode:: python

    s = 'a,b.A8A?B'
    Counter(c.lower() for c in s
            if c.isalpha())
    # ?


Counting Letters (CI)
---------------------
.. sourcecode:: python

    s = 'a,b.A8A?B'
    Counter(c.lower() for c in s
            if c.isalpha())
    # Counter({'a': 3, 'b': 2})


Couting words
-------------
.. sourcecode:: python

    text = 'foo bar foo'
    Counter(text.split())
    # ?


Couting words
-------------
.. sourcecode:: python

    text = 'foo bar foo'
    Counter(text.split())
    # Counter({'foo': 2, 'bar': 1})


Questions?
----------

.. image:: qr.svg
   :class: qrcode

* bmispelon@gmail.com
* `github.com/bmispelon`__
* twitter: `@bmispelon`__
* IRC: bmispelon on Freenode (#python, #django)

__ https://github.com/bmispelon/presentations
__ https://twitter.com/bmispelon
