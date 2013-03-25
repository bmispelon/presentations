.. include:: <s5defs.txt>

GCBV: TL;DR
===========

.. sourcecode:: python

    from django.views import generic


Presentation
------------

* **Views**: :black:`definition, contrived examples.`
* **Class-based views**: :black:`making views out of classes.`
* **Generic views**: :black:`history, comparison, implementation.`
* **Mixins**: :black:`building blocks for reusable views.`
* **Tips**: :black:`making it harder to shoot yourself in the foot.`


What's a view?
--------------

The view contract (3 rules):
    * Callable
    * Takes a request (+captured URL parameters)
    * Return a response object


What's a "callable"?
--------------------


A function
----------

.. sourcecode:: python

    def f():
        return 42

    f() # 42


A function
----------

.. sourcecode:: python

    def function_view(request, foo):
        return HttpResponse('OK: %s' % foo)


An anonymous function
---------------------

.. sourcecode:: python

    f = lambda: 42

    f() # 42


An anonymous function
---------------------

.. sourcecode:: python

    lambda request, foo: HttpResponse('OK: %s' % foo)


A method
--------

.. sourcecode:: python

    class C(object):
        def m(self):
            return 42

    instance = C()

    f = instance.m

    f() # 42


A method
--------

.. sourcecode:: python

    class ViewClass(object):
        def view(self, request, foo):
            return HttpResponse('OK: %s' % foo)

    method_view = ViewClass().view


A classmethod
-------------

.. sourcecode:: python

    class C(object):
        @classmethod
        def m(self):
            return 42

    f = C.m

    f() # 42


A classmethod
-------------

.. sourcecode:: python

    class ViewClass(object):
        @classmethod
        def view(cls, request, foo):
            return HttpResponse('OK: %s' % foo)

    method_view = ViewClass.view


An callable instance
--------------------

.. sourcecode:: python

    class C(object):
        def __call__(self):
            return 42

    f = C()

    f() # 42


An callable instance
--------------------

.. sourcecode:: python

    class ViewClass(object):
        def __call__(self, request, foo):
            return HttpResponse('OK: %s' % foo)

    instance_view = ViewClass()


A class
-------

.. sourcecode:: python

    class F(int):
        def __init__(self)
            super(F, self).__init__(42)

    F() # 42


A class
-------

.. sourcecode:: python

    class ClassView(HttpResponse):
        def __init__(self, request, foo):
            super(ClassView, self).__init__('OK: %s' % foo)

    class_view = ClassView


A class
-------

.. sourcecode:: python

    class F(object):
        def __new__(cls):
            return 42

    F() # 42


A class
-------

.. sourcecode:: python

    class ClassView(object):
        def __new__(cls, request, foo):
            return HttpResponse('OK: %s' % foo)

    class_view = ClassView


Presentation
------------

Interlude


Class-Based Views (CBV)
-----------------------

Django 1.3 shipped a new ``View`` class that can be used to make
views out of classes.

Confusingly, it's located in ``django.views.generic``, but it's
not itself a generic view (only a base).


Anatomy of ``generic.View``
---------------------------

It's a plain python class (no metaclass magic).

Derives directly from ``object``.

Implements a ``dispatch`` method, which will route requests to a different method
based on the HTTP verb (GET, POST, PUT, DELETE, ...).

A classmethod ``as_view`` that creates and return the actual view callable
(which calls the instance's ``dispatch`` under the hood').


Simple example
--------------

.. sourcecode:: python

    class MyView(View):
        template_name = 'hello.html'
        message = 'Hello world!'

        def get(self, request):
            return render(request,
                self.template_name,
                {'message': self.message}
            )

    view_en = MyView.as_view()
    view_hu = MyView.as_view(template_name='szia.html')


Anatomy of generic.View
-----------------------

.. sourcecode:: python

    class View(object):
        def __init__(self, **initkwargs):
            for k, v in initkwargs.items():
                setattr(self, k, v) # self.foo = bar

        @classmethod
        def as_view(cls, **initkwargs):
            cbv = cls(**initkwargs)
            return cbv.dispatch

        def dispatch(self, request, *args, **kwargs):
            handler = getattr(self, request.method)
            return handler(request, *args, **kwargs)


Advantages
----------

* Declarative style

* Reusability through inheritance/composition

* Good code isolation (methods)

* HTTP methods separation (good for APIs)


Presentation
------------

Interlude


Generic views
-------------

Shipped with django since the beginning.

A set of readymade common views, with extension hooks.


Generic Views
-------------

Historically, django has been shipping **function**-based generic views (GFBV).

But they were limited, so it switched to **class**-based ones (GCBV) with 1.3.

The deprecation policy was followed, and with 1.5, GFBV are now gone.


History of generic views
------------------------

.. table:: :class: history

    =======  ==============   ===========
    Version  Function-based   Class-based
    =======  ==============   ===========
    1.0      ☀                ☁
    1.1      ☀                ☁
    1.2      ☀                ☁
    1.3      ☂                ☀
    1.4      ☂                ☀
    1.5      ☁                ☀
    =======  ==============   ===========

.. raw:: html

    <script type="text/javascript" src="20130327_django_cbv.js"></script>


An old function-based generic view
----------------------------------

.. sourcecode:: python

    def update_object(request, model=None, object_id=None,
        slug=None, slug_field='slug', template_name=None,
        template_loader=loader, extra_context=None,
        post_save_redirect=None, login_required=False,
        context_processors=None, template_object_name='object',
        form_class=None):

        ...


Problems
--------

* Mixes captured URL parameters and extension hooks;
* Each extension hook requires a new argument to the function;
* Repeated logic between generic views;


The new way: CBV
----------------

* Clear separation of request parameters and extension hooks;
* Extensible through python class inheritance/composition;
* Centralized logic through mixins.


Not all rainbows
----------------

* Verbosity
* Performance cost (measure)
* Lots of layers (RKK)
* Bad documentation (getting better)


Not all rainbows
----------------

.. image:: cbv.png


The generic views
-----------------

* RedirectView
* TemplateView
* ListView
* DetailView
* FormView
* CreateView
* UpdateView
* DeleteView
* (and some date-related ones, not covered here)


Examples
--------


Rendering a template
--------------------

.. sourcecode:: python

    from django.shortcuts import render

    def homepage(request):
        return render(request,
            'homepage.html'
        )


Rendering a template
--------------------

.. sourcecode:: python

    homepage = generic.TemplateView(
        template_name='homepage.html'
    )


List some models
----------------

.. sourcecode:: python

    def article_list(request):
        queryset = Article.objects.all()
        return render(request,
            'blog/article_list.html',
            {'object_list': queryset}
        )


List some models
----------------

.. sourcecode:: python

    article_list = generic.Listview(
        model=Article,
        template_name='blog/article_list.html',
    )


List some models
----------------

.. sourcecode:: python

    article_list = generic.Listview(
        model=Article,
    )


Display a particular model
--------------------------

.. sourcecode:: python

    def article_detail(request, pk):
        article = get_object_or_404(Article, pk=pk)
        return render(request,
            'blog/article_detail.html',
            {'object': article}
        )


Display a particular model
--------------------------

.. sourcecode:: python

    article_detail = generic.DetailView(
        model=Article,
        template_name='blog/article_detail.hml',
    )


Display a particular model
--------------------------

.. sourcecode:: python

    article_detail = generic.DetailView(
        model=Article,
    )


Update a model
--------------

.. sourcecode:: python

    def article_update(request, pk):
        article = get_object_or_404(Article, pk=pk)
        if request.method == 'POST':
            form = ArticleForm(request.POST, instance=article)
            if form.is_valid():
                form.save()
                return HttpResponseRedirect('/articles/')
        else:
            form = ArticleForm(instance=article)
        return render(request,
            'blog/article_form.html',
            {'form': form, 'object': article}
        )


Update a model
--------------

.. sourcecode:: python

    article_update = generic.UpdateView(
        model=Article,
        form_class=ArticleForm,
        success_url='/articles/',
        template_name='blog/article_form.html',
    )


Update a model
--------------

.. sourcecode:: python

    article_update = generic.UpdateView(
        model=Article,
        form_class=ArticleForm,
        success_url='/articles/',
    )


Delete a model
--------------

.. sourcecode:: python

    def article_delete(request, pk):
        article = get_object_or_404(Article, pk=pk)
        if request.method == 'POST':
            article.delete()
            return HttpResponseRedirect('/articles/')
        return render(request,
            'blog/article_delete.html',
            {'object': article}
        )


Delete a model
--------------

.. sourcecode:: python

    article_delete = generic.DeleteView(
        model=Article,
        success_url='/articles/',
        template_name='blog/article_delete.html',
    )


Delete a model
--------------

.. sourcecode:: python

    article_delete = generic.DeleteView(
        model=Article,
        success_url='/articles/',
    )


Presentation
------------

Interlude


What is a mixin?
----------------

Just a normal python class.

Not instanciated on its own.

Usually needs to be combined with a more "concrete" one to fully work.


Why use them?
-------------

Share code (methods or attributes) between two views of different nature.

Isolate functionalities in one single unit of code (more maintainable).

A bit like a decorator for a functional view, but with more dimensions.


LoginRequiredMixin
------------------

.. sourcecode:: python

    class LoginRequiredMixin(object):
        "Equivalent of login_required decorator."

        def dispatch(self, request, *args, **kwargs):
            if request.user.is_anonymous():
                return redirect_to_login(request.get_full_path())
            return super(LoginRequiredMixin, self).dispatch(
                request, *args, **kwargs)
            )


Usage
-----

.. sourcecode:: python

    class ProtectedView(LoginRequiredMixin, generic.View):
        def get(self, request):
            username = request.user.username
            return HttpResponse('Hello %s' % username)


UserQuerysetMixin
-----------------

.. sourcecode:: python

    class UserQuerysetMixin(object):
        "Filter the queryset by the current user."

        def get_queryset(self):
            queryset = super(UserQuerysetMixin, self).\
                get_queryset()
            return queryset.filter(user=self.request.user)


Usage
-----

.. sourcecode:: python

    class Comment(models.Model):
        user = models.ForeignKey('auth.User')
        article = models.ForeignKey('blog.Article')
        created_on = models.DateTimeField(default=timezone.now)
        body = models.TextField()

    class MyArticlesListView(LoginRequiredMixin,
                             UserQuerysetMixin, ListView):
        model = Article

    # Will only show articles for which the current logged-in
    # user is the owner.


Usage (2)
---------

.. sourcecode:: python

    class Comment(forms.ModelForm):
        class Meta:
            model = Article
            fields = ('body',)

    class ArticleUpdateView(LoginRequiredMixin, UpdateView):
        model = Article
        form_class = ArticleForm

    # Will let any logged-in user updated any post
    # if they know the id.


Usage (2)
---------

.. sourcecode:: python

    class Comment(forms.ModelForm):
        class Meta:
            model = Article
            fields = ('body',)

    class ArticleUpdateView(LoginRequiredMixin,
                            UserQuerysetMixin, UpdateView):
        model = Article
        form_class = ArticleForm

    # Will only let a user update the articles he/she authored.
    # Will raise a 404 otherwise.


SelectRelatedMixin
------------------

.. sourcecode:: python

    class SelectRelatedMixin(object):
        select_related = ()
        def get_queryset(self):
            queryset = super(SelectRelatedMixin, self).\
                get_queryset()
            return queryset.select_related(*self.select_related)


Usage
-----

.. sourcecode:: python

    class ArticleListView(SelectRelatedMixin, ListView):
        model = Article
        select_related = ('article',)

    # will perform Article.objects.select_related('article')


Combining
---------

.. sourcecode:: python

    class MyArticleListView(LoginRequiredMixin, UserQuerysetMixin,
                            SelectRelatedMixin, ListView):
        model = Article
        select_related = ('article',)

    # Article.objects.filter(user=user).select_related('article')


Presentation
------------

Interlude


In practice
-----------

Only a few attributes/methods are commonly changed:

* **Attributes**: ``template_name``, ``model``, ``form_class``,
                  ``pk_url_kwarg``, ``context_object_name``

* **Methods**: ``get_queryset``, ``get_form_kwargs``, ``get_form_initial``


Tips for not shooting yourself in the foot
------------------------------------------

Don't force a round peg through a square hole: fallback to ``generic.View`` if things get messy.

Don't complicate your mixins: make them do one thing only but use lots of them.

Have your mixins inherit from ``object`` (or another mixin), never from a concrete view.

Read left to right: mixins on the left, one single view on the right.

Always call ``super(...)`` when overriding a method (don't break the chain).


Style tip: urls.py
------------------

.. sourcecode:: python

    # views.py
    class MyView(View):
        # some code here
    
    
    # urls.py
    from myapp.views import MyView

    url(r'^/foo/$', MyView.as_view(foo='bar')) # ugly


Style tip: urls.py
------------------

.. sourcecode:: python

    # views.py
    class MyView(View):
        # some code here
    
    my_view = MyView.as_view(foo='bar')
    
    
    # urls.py

    url(r'^/foo/$', 'myapp.my_view') # better, transparent


Style tip: urls.py
------------------

.. sourcecode:: python

    # views.py
    class MyView(View):
        # some code here
    
    my_view = MyView.as_view(foo='bar')
    
    
    # urls.py
    from myapp.views import my_view

    url(r'^/foo/$', my_view) # even better for debugging


Presentation
------------

Interlude
