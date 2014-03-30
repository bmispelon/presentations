.. include:: <s5defs.txt>

.. role:: strike
    :class: strike

How the Sausage is Made
=======================

.. container:: fullheight

    Looking at Django's development process from the inside.


About me
--------

.. image:: baptiste.jpg
   :class: floatleft

**Baptiste Mispelon**

Online: ``bmispelon``

Web developer

Django core dev since June 2013


About this talk
---------------

Three parts:

1) What is Django?
2) How is Django developed?
3) How to contribute?


1 - What is Django?
-------------------

.. container:: fullheight

    .. image:: django-pony.png
       :class: center


The framework
-------------

*"The web framework for perfectionists with deadlines"*

.. class:: incremental

    * Written in Python
    * Batteries included: ORM, template language, ...
    * MIT license
    * Supports Python 3 and 2


History
-------

.. class:: incremental

    * Started in **2003** at World Online, web division of LJW (US newspaper).
    * Opensourced in July **2005**.
    * ``1.0`` release in September **2008**.
    * Currently at **1.6**, with **1.7** in beta.


The DSF
-------

\ **D**\ jango \ **S**\ oftware \ **F**\ oundation

.. class:: incremental

    * Created in 2008
    * US-based non-profit organization
    * Funded by corporate members and donations


The DSF's activity
------------------

.. class:: incremental

    * Holds the Django trademark
    * Helps sponsor sprints, meetups, ...
    * Awards (Malcolm Tredinnick memorial prize)


The core team
-------------

.. class:: incremental

    .. image:: core_team.jpg


The core team
-------------

Core team == People with commit access.

.. class:: incremental

    * 44 people, 16 countries, 3 continents
    * All volunteers, no one is paid


Core team's activity
--------------------

.. class:: incremental

    * Free time vary so people come and go
    * Active core devs (by commit):
        * this week: 9
        * this month: 17
        * this year: 32


Perks
-----

.. class:: incremental

    * Commit access (really scary)
    * Internal mailing list (not very active)
    * Private repository (to work on security issues)
    * Access to a private Django jet


Perks
-----

* Commit access (really scary)
* Internal mailing list (not very active)
* Private repository (to work on security issues)
* :strike:`Access to a private Django jet`
* **That's basically all**


How to join the core team?
--------------------------

.. class:: incremental

    * Don't ask for it
    * Quality contributions
    * Long-term involvement
    * Existing core dev submits name for approval. One week voting period. +1/-1


The community
-------------

Django's most valuable asset.


Code contributions
------------------

We have 10 times as many external contributors as core devs:

.. sourcecode:: bash

    $ git log --format=%an \
        | sort -u \
        | wc -l
    584


Ecosystem
---------

There's a huge wealth of reusable applications:

.. sourcecode:: bash

    $ pip search django \
        | grep ^django- \
        | wc -l
    4061


Community events
----------------

Conferences all over the world:

USA, Europe, Australia,  
Wales, Italy, ...

There are also regular meetups everywhere.

Not to mention all Python-related events.


2 - How is Django developed?
----------------------------

.. container:: fullheight

    .. image:: pony_factory.png
       :class: center


Release process
---------------

.. class:: incremental

    * New release about every 6 months
    * Alpha (4 months), Beta (2 months), RC (2 weeks), Final
    * Micro release for bugfix/security
    * **L**\ ong-\ **T**\ erm **S**\ upport
    * Backwards-compatibility policy


Git / Github
------------

.. class:: incremental

    * Django started with Subversion but moved to Git in April 2012
    * ~17 000 commits
    * `github.com/django/django <https://github.com/django/django>`_
    * No issues, no wiki
    * Pull requests (2500 opened)


Trac
----

.. class:: incremental

    * Bug tracking software written in Python
    * Used since the beginning of the project
    * Central to the development of Django
    * More than 22 000 issues
    * Intimidating but powerful
    * **Don't use it for security reports!**


Protip: the Django dashboard
----------------------------

https://dashboard.djangoproject.com

Pretty graphs, useful shortcuts to trac.


Django dashboard
----------------

.. image:: Django_dashboard.png


Mailing lists
-------------

Big features are discussed on ``django-developers``.

Someone comes with a proposal and people discuss it, gathering feedback.

The goal is to reach a consensus from which we can start building.


Other official mailing lists
----------------------------

* ``django-users``
* ``django-core-mentorship``
* ``django-i18n``
* ``django-announce``
* ``django-updates``


Internationalization
--------------------

Django is translated in 81 languages:

.. class:: incremental

    * Translation work is done on Transifex_
    * Anybody is welcome to contribute (you need to create an account and join a language team)
    * Experimental: Translation of the documentation (French, Japanese)

.. _Transifex: https://www.transifex.com/projects/p/django-core/


Translation process
-------------------

.. class:: incremental

    * Strings to translate are extracted and appear on Transifex
    * Language teams translate them
    * "String freeze" when RC is released
    * When the release is packaged, translated strings are pulled from Transifex and included in the final package.


3 - How to contribute?
----------------------

.. container:: fullheight

    .. image:: pony_puzzle.png
       :class: center


Help others
-----------

.. class:: incremental

    * Great way to get a better understanding of Django's internals
    * IRC: ``#django`` on Freenode (``#django-pl``?)
    * ``django-users`` mailing list


Try early versions
------------------

We release Alpha, Beta, and RC versions.

Test them in your own projects before they're released.


How to install a pre-release?
-----------------------------

Use **virtualenv** and **pip**::

    pip install \
     https://www.djangoproject.com/\
     download/1.7b1/tarball/


How to install a pre-release?
-----------------------------

Use **virtualenv** and **pip**::

    pip install -e \
     git+https://github.com/\
     django/django.git@1.7b1


How to install a pre-release?
-----------------------------

Use **virtualenv** and **pip**::

    pip install --pre Django==1.7b1

.. class:: incremental

    (soon)


Report bugs
-----------

Sooner or later, you'll find a bug:

.. class:: incremental

    * Typo ⇒ pull request
    * Anything more complex ⇒ new ticket on Trac
    * **Don't report security issues on Trac!**


A good ticket
-------------

Reproducability is key:

.. class:: incremental

    * Show us your code + steps
    * Show tracebacks
    * Give information about your platform (OS, libs, ...)
    * Reduce the scope


Triage
------

There's about 5-10 new tickets opened every day.

Anybody can help out, not just core devs.


What to do on Trac?
-------------------

.. class:: incremental

    * Process unreviewed tickets (accept, reject)
    * Make sure old bugs are still present
    * Review patches/pull requests


Contribute code and docs
------------------------

.. class:: incremental

    * Write fixes for existing tickets
    * Write documentation
    * Improve existing patches (add missing tests, docs, ...)


Write libraries
---------------

Django's strength is also the huge amount of libraries written for it.

Promote quality: tests, documentation, Python 3 support, ...


Blog
----

.. class:: incremental

    Not everything has its place in the documentation.

    Some things are better left for the community to document.

    Why not write your own blog engine with Django?


Attend events
-------------

.. class:: incremental

    Meet the community, become part of it.

    Learn about cool new stuff.

    Make friends!


Level up
--------

.. class:: incremental

    Can't find an event you'd like to attend?

    Why not organize your own?

    You won't get to sleep for days, but you'll learn a ton and it'll give you a new perspective.


Something for everyone
----------------------

* International conferences
* Meetup
* Sprints


Conclusion
----------

.. class:: incremental

    Django is a **community** project.

    We want **openness** and **transparency**.

    Anything else is a **bug**.

    .. class:: center

        **Help us fix it!**


Dziękuję!
---------

.. container:: fullheight

    Pytania?


Bonus: my merge workflow
------------------------

.. sourcecode:: bash

    wget https://github.com/\
        django/django/pull/XXXX.patch
    git apply XXXX.patch
    PYTHONPATH=. python tests/runtests.py
    git checkout -- django/
    PYTHONPATH=. python tests/runtests.py
    git checkout -- .
    git am XXXX.patch
    git push
    # Close PR.


Links
-----

Django's site: 'https://www.djangoproject.com
The code: https://github.com/django/django
DSF: https://www.djangoproject.com/foundation/
Contributing: https://docs.djangoproject.com/en/dev/internals/contributing/
Contributing (not specific to Django): https://dont-be-afraid-to-commit.readthedocs.org/en/latest/contributing.html
Django dashboard: https://dashboard.djangoproject.com
Continuous integration (with coverage): https://ci.djangoproject.com
Translation: https://www.transifex.com/projects/p/django-core/
