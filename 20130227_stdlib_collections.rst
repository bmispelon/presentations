.. include:: <s5defs.txt>

Rediscovering the stdlib
========================

The collections module


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
.. sourcecode:: python

    from collections import (
        deque,       # 2.4
        defaultdict, # 2.5
        namedtuple,  # 2.6
        OrderedDict, # 2.7
        Counter,     # 2.7
        abc,         # Not covered here
    )


1: collections.deque
--------------------

List-like container with fast appends and pops on either end.

Introduced in python 2.4.

Short for "doubled-ended queue".


Time Complexity
---------------
.. table::

    ===========    ====
    Operation      list
    ===========    ====
    append         O(1)
    pop (right)    O(1)
    prepend        O(n)
    pop (left)     O(n)
    ===========    ====


Time Complexity
---------------
.. table::

    ===========    =====
    Operation      deque
    ===========    =====
    append         O(1)
    pop (right)    O(1)
    prepend        O(1)
    pop (left)     O(1)
    ===========    =====


Operations
----------
.. table::

    ==============    ==============
    list              deque
    ==============    ==============
    l.append(x)       d.append(x)
    l.pop()           d.pop()
    l.insert(x, 0)    d.appendleft()
    l.pop(0)          d.popleft()
    ==============    ==============


Initialization
--------------
.. sourcecode:: python

    >>> deque()
    deque([])


Initialization
--------------
.. sourcecode:: python

    >>> deque()
    deque([])
    >>> deque('abcdef')
    deque(['a', 'b', 'c', 'd', 'e', 'f'])


Initialization
--------------
.. sourcecode:: python

    >>> deque()
    deque([])
    >>> deque('abcdef')
    deque(['a', 'b', 'c', 'd', 'e', 'f'])
    >>> deque('abcdef', maxlen=3)
    deque(['d', 'e', 'f'], maxlen=3)


Practical Example
-----------------

Print the last 20 lines of a file.

.. sourcecode:: bash

    $ tail -n 20 some_file.txt


Option 1: Naive
---------------
.. sourcecode:: python

    with open('some_file.txt') as f:
        last = list(f)[-20:] ###
    print "\n".join(last)


Option 2: More Robust
---------------------
.. sourcecode:: python

    last = []
    with open('some_file.txt') as f:
        for line in f:
            last.append(line)
            if len(last) > 20:
                last = last[1:] ###
    print "\n".join(last)


Option 3: deque
---------------
.. sourcecode:: python

    with open('some_file.txt') as f:
        last = deque(f, maxlen=20) ###
    print "\n".join(last)


2: collections.defaultdict
--------------------------

Dict subclass that calls a factory function to supply missing values.

Introduced in python 2.5.


Initialization
--------------
.. sourcecode:: python

    f = lambda: None # factory
    defaultdict()
    defaultdict(f)
    defaultdict(f, {'foo': 'bar'})
    defaultdict(f, [('foo', 'bar')])

Note: if no factory is given, defaultdict behaves exactly like dict.


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
    dd = defaultdict(factory, rd)
    dd['foo']     # ?


Missing Keys
------------
.. sourcecode:: python

    factory = lambda: 'X'
    dd = defaultdict(factory, rd)
    dd['foo']     # 'bar'


Missing Keys
------------
.. sourcecode:: python

    factory = lambda: 'X'
    dd = defaultdict(factory, rd)
    dd['foo']     # 'bar'
    dd['missing'] # ?


Missing Keys
------------
.. sourcecode:: python

    factory = lambda: 'X'
    dd = defaultdict(factory, rd)
    dd['foo']     # 'bar'
    dd['missing'] # 'X'


Example of factories
--------------------

* bool, int, float, complex, str, list, dict, set, ...
* lambda: defaultdict(int) (two-level deep)
* {'a': 'b'}.copy


Practical Example
-----------------

Given a list of payments (date, amount),

we want to get a mapping of {date: [amounts]}


Option 1: naive
---------------
.. sourcecode:: python

    d = {}
    for date, amount in L:
        if date not in L:
            d[date] = []
        d[date].append(amount)


Option 2: Improved
------------------
.. sourcecode:: python

    d = {}
    for date, amount in L:
        l = d.setdefault(date, [])
        l.append(amount)


Option 3: defaultdict
---------------------
.. sourcecode:: python

    d = defaultdict(list)
    for date, amount in L:
        d[date].append(amount)


.format() With Defaults
-----------------------
.. sourcecode:: python

    factory = lambda: '___'
    d = defaultdict(factory, foo='yes')
    print('{foo} {bar}'.format(d))
    # ?


.format() With Defaults
-----------------------
.. sourcecode:: python

    factory = lambda: '___'
    d = defaultdict(factory, foo='yes')
    print('{foo} {bar}'.format(d))
    # 'yes ___'


Auto-vivifying Tree
-------------------
.. sourcecode:: python

    # don't try this at home!
    def factory():
        return defaultdict(factory)
    d = defaultdict(factory)
    
    d['a']['b']['c'] = 42


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

    namedtuple('Point', ['x', 'y', 'z'])
    namedtuple('Point', 'x y z')
    namedtuple('Point', 'x,y,z')


Initialization
--------------
.. sourcecode:: python

    namedtuple('Point', ['x', 'y', 'z'])
    namedtuple('Point', 'x y z')
    namedtuple('Point', 'x,y,z')
    # Creates **classes**,
    #     not **instances**.


Accessing Fields
----------------
.. sourcecode:: python

    Point = namedtuple('Point', 'x y z')
    p = Point(x=23, y=10, z=85)
    p[0] # ?


Accessing Fields
----------------
.. sourcecode:: python

    Point = namedtuple('Point', 'x y z')
    p = Point(x=23, y=10, z=85)
    p[0] # 23


Accessing Fields
----------------
.. sourcecode:: python

    Point = namedtuple('Point', 'x y z')
    p = Point(x=23, y=10, z=85)
    p[0] # 23
    p.z  # ?


Accessing Fields
----------------
.. sourcecode:: python

    Point = namedtuple('Point', 'x y z')
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

Dict subclass that remembers the order entries were added.

Introduced in python 2.7.


Initialization
--------------

Identical to dict.


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


Bringing Back Order
-------------------

OrderDict are ordered by insertion order:

.. sourcecode:: python

    s = 'abc'
    d = OrderedDict.fromkeys('abc')
    ''.join(d) # ?


Bringing Back Order
-------------------

OrderDict are ordered by insertion order:

.. sourcecode:: python

    s = 'abc'
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

Dict subclass for counting hashable objects.

Introduced in python 2.7.

Basically a defaultdict(int),  
with some useful methods added.


Initialization
--------------

.. sourcecode:: python

    Counter(some_iterable)
    # dict (keys)
    # list
    # generator
    # str (characters)


Counting Characters
-------------------
.. sourcecode:: python

    # First approach, with a plain dict:
    counter = {}
    for letter in s:
        if letter not in counter:
            counter[letter] = 0
        counter[letter] += 1


Counting Characters
-------------------
.. sourcecode:: python

    # Improved:
    counter = {}
    for letter in s:
        current = counter.get(letter, 0)
        counter[letter] = current + 1


Counting Characters
-------------------
.. sourcecode:: python

    # Third approach, with a defaultdict
    counter = defaultdict(int)
    for letter in s:
        counter[letter] += 1


Counting Characters
-------------------
.. sourcecode:: python

    # Finally, with a Counter
    counter = Counter(s) # done.


Letters Only
------------
.. sourcecode:: python

    Counter(c for c in s
            if c.isalpha())


Letters Only
------------
.. sourcecode:: python

    Counter(c for c in s
            if c.isalpha())
    Counter(c.lower() for c in s
            if c.isalpha())
    # Case-insensitive


Couting words
-------------
.. sourcecode:: python

    Counter(text.split())


Couting words
-------------
.. sourcecode:: python

    Counter(text.split())
    # Simplistic: no handling of punctuation


Counter.elements()
----------------------
.. sourcecode:: python

    c = Counter('ababac')
    c.elements()
    # ?


Counter.elements()
----------------------
.. sourcecode:: python

    c = Counter('ababac')
    c.elements()
    # ['a', 'a', 'a', 'b', 'b', 'c']


Counter.most_common(N)
----------------------
.. sourcecode:: python

    c = Counter('aaabbc')
    c.most_common(1) # ?


Counter.most_common(N)
----------------------
.. sourcecode:: python

    c = Counter('aaabbc')
    c.most_common(1) # [('a', 3)]


Counter.most_common(N)
----------------------
.. sourcecode:: python

    c = Counter('aaabbc')
    c.most_common(1) # [('a', 3)]
    c.most_common()
    # ?


Counter.most_common(N)
----------------------
.. sourcecode:: python

    c = Counter('aaabbc')
    c.most_common(1) # [('a', 3)]
    c.most_common()
    # [('a', 3), ('b', 2), ('c', 1)]


Counter.update()
----------------
.. sourcecode:: python

    c = Counter('aaabb')
    c.update(a=2, b=1)
    c # ?


Counter.update()
----------------
.. sourcecode:: python

    c = Counter('aaabb')
    c.update(a=2, b=1)
    c # Counter({'a': 5, 'b': 3})


Counter.substract()
-------------------
.. sourcecode:: python

    c = Counter('aaabb')
    c.substract(a=2, b=1)
    c # ?


Counter.substract()
-------------------
.. sourcecode:: python

    c = Counter('aaabb')
    c.substract(a=2, b=1)
    c # Counter({'a': 1, 'b': 1})


Counter Is A dict!
------------------
.. sourcecode:: python

    # Total number of elements:
    counter = Counter('aaabbc')
    sum(counter.values()) # ?


Counter Is A dict!
------------------
.. sourcecode:: python

    # Total number of elements:
    counter = Counter('aaabbc')
    sum(counter.values()) # 6


Counter Is A dict!
------------------
.. sourcecode:: python

    # Freeze the counter:
    counter = Counter('aaabbc')
    dict(counter)
    # ?


Counter Is A dict!
------------------
.. sourcecode:: python

    # Freeze the counter:
    counter = Counter('aaabbc')
    dict(counter)
    # {'a': 3, 'b': 2, 'c': 1}


Counter Is A dict!
------------------
.. sourcecode:: python

    # List of unique elements:
    counter = Counter('aaabbc')
    counter.keys()
    # ?


Counter Is A dict!
------------------
.. sourcecode:: python

    # List of unique elements:
    counter = Counter('aaabbc')
    counter.keys()
    # ['a', 'b', 'c']


Counter Is A dict!
------------------
.. sourcecode:: python

    # Count for a given element:
    counter = Counter('aaabbc')
    counter['a'] # ?


Counter Is A dict!
------------------
.. sourcecode:: python

    # Count for a given element:
    counter = Counter('aaabbc')
    counter['a'] # 3


Counter Is A dict!
------------------
.. sourcecode:: python

    # Count for a given element:
    counter = Counter('aaabbc')
    counter['a'] # 3
    counter['d'] # ?


Counter Is A dict!
------------------
.. sourcecode:: python

    # Count for a given element:
    counter = Counter('aaabbc')
    counter['a'] # 3
    counter['d'] # 0


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

* email: bmispelon@gmail.com
* https://github.com/bmispelon (for slides)
* twitter: @bmispelon
* IRC: bmispelon on Freenode (#python, #django)
