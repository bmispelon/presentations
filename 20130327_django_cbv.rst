.. include:: <s5defs.txt>

GCBV: TL;DR
===========

.. sourcecode:: python

    from django.views import generic

Class-based generic views in Django.


About me
--------

Baptiste Mispelon (bmispelon)

I've been using django for almost 4 years (started with 1.1).

Currently doing web development with django at `M2BPO`__.

__ http://www.m2bpo.fr


Introduction
------------

Views, class-based views, generic views, function-based views: it's confusing.

I'm going to try and clarify things.


Presentation
------------

* **Views**: :black:`definition, contrived examples.`
* **Class-based views**: :black:`making views out of classes.`
* **Generic views**: :black:`history, comparison, implementation.`
* **Mixins**: :black:`building blocks for reusable views.`
* **Tips**: :black:`making it harder to shoot yourself in the foot.`


Presentation
------------

* **Views**: :navy:`definition, contrived examples.`
* **Class-based views**: :black:`making views out of classes.`
* **Generic views**: :black:`history, comparison, implementation.`
* **Mixins**: :black:`building blocks for reusable views.`
* **Tips**: :black:`making it harder to shoot yourself in the foot.`


Let's start with the basics
---------------------------


What's a view?
--------------


What's a view?
--------------

The view contract.


What's a view?
--------------

The view contract.

A view is:


What's a view?
--------------

The view contract.

A view is:
    * a callable


What's a view?
--------------

The view contract.

A view is:
    * a callable
    * that takes a request argument (+captured URL parameters)


What's a view?
--------------

The view contract.

A view is:
    * a callable
    * that takes a request argument (+captured URL parameters)
    * and return a response object


What's a "callable"?
--------------------


A function
----------

.. sourcecode:: python

    def f():
        return 42

    f() # 42


A function (view)
-----------------

.. sourcecode:: python

    def function_view(request, foo):
        return HttpResponse('OK: %s' % foo)


An anonymous function
---------------------

.. sourcecode:: python

    f = lambda: 42

    f() # 42


An anonymous function (view)
----------------------------

.. sourcecode:: python

    lambda request, foo: HttpResponse('OK: %s' % foo)


A method on an instance
-----------------------

.. sourcecode:: python

    class C(object):
        def m(self):
            return 42

    instance = C()

    f = instance.m

    f() # 42


A method on an instance (view)
------------------------------

.. sourcecode:: python

    class ViewClass(object):
        def view(self, request, foo):
            return HttpResponse('OK: %s' % foo)

    method_view = ViewClass().view


A method on a class
-------------------

.. sourcecode:: python

    class C(object):
        @classmethod
        def m(self):
            return 42

    f = C.m

    f() # 42


A method on a class (view)
--------------------------

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


An callable instance (view)
---------------------------

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
            int.__init__(42)

    F() # 42


A class (view)
--------------

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


A class (view)
--------------

.. sourcecode:: python

    class ClassView(object):
        def __new__(cls, request, foo):
            return HttpResponse('OK: %s' % foo)

    class_view = ClassView


Presentation
------------

* **Views**: :gray:`definition, contrived examples.`
* **Class-based views**: :navy:`making views out of classes.`
* **Generic views**: :black:`history, comparison, implementation.`
* **Mixins**: :black:`building blocks for reusable views.`
* **Tips**: :black:`making it harder to shoot yourself in the foot.`


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
(which calls the instance's ``dispatch`` under the hood).


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


Advantages
----------

* Declarative style

* Reusability through inheritance

* Good code isolation (methods)

* HTTP methods separation (good for APIs)


Presentation
------------

* **Views**: :gray:`definition, contrived examples.`
* **Class-based views**: :gray:`making views out of classes.`
* **Generic views**: :navy:`history, comparison, implementation.`
* **Mixins**: :black:`building blocks for reusable views.`
* **Tips**: :black:`making it harder to shoot yourself in the foot.`


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
* Extensible through python class inheritance;
* Centralized logic through mixins.


How does it work?
-----------------

It's simple...


Simple, right?
--------------

.. image:: cbv.png


OK, maybe not
-------------

But that's just the internal implementation, you don't have to know it by heart.

(Though it helps, and it starts to make sens after a while)


Not all rainbows
----------------

* Verbosity
* Performance cost (measure)
* Lots of layers (RKK)
* Documentation (was bad, is getting better)


How to use a generic view?
--------------------------

Two ways:
    * Pass attributes to ``as_view``
    * Subclass


Simple case: passing attributes to ``as_view``
----------------------------------------------

.. sourcecode:: python

    view = CreateView.as_view(
                model=MyOwnModel,
                template_name='custom_template.html'
    )


Custom logic: subclassing
-------------------------

.. sourcecode:: python

    class ContactView(DeleteView):
        form_class = ContactForm
        
        def form_valid(self, form):
            form.send_email()
            return super(ContactView, self).form_valid(form)

    view = ContactView.as_view()


Examples of generic view usage
------------------------------


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


All the generic views
---------------------

* RedirectView
* TemplateView
* ListView
* DetailView
* FormView
* CreateView
* UpdateView
* DeleteView
* (and some date-related ones, not covered here)


Presentation
------------

* **Views**: :gray:`definition, contrived examples.`
* **Class-based views**: :gray:`making views out of classes.`
* **Generic views**: :gray:`history, comparison, implementation.`
* **Mixins**: :navy:`building blocks for reusable views.`
* **Tips**: :black:`making it harder to shoot yourself in the foot.`


What is a mixin?
----------------

Just a normal python class.

Not instanciated on its own.

Needs to be combined with a more "concrete" one to fully work.


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

    class MyCommentsListView(LoginRequiredMixin,
                             UserQuerysetMixin, ListView):
        model = Comment

    # Will only show the comments of the current user.


Usage (2)
---------

.. sourcecode:: python

    class CommentForm(forms.ModelForm):
        class Meta:
            model = Comment
            fields = ('body',)

    class ArticleUpdateView(LoginRequiredMixin, UpdateView):
        model = Comment
        form_class = CommentForm

    # Will let any logged-in user update any comment
    # if they know the id.


Usage (2)
---------

.. sourcecode:: python

    class Comment(forms.ModelForm):
        class Meta:
            model = Comment
            fields = ('body',)

    class ArticleUpdateView(LoginRequiredMixin,
                            UserQuerysetMixin, UpdateView):
        model = Comment
        form_class = CommentForm

    # Will only let a user update the comments he/she authored.
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

    class CommentListView(SelectRelatedMixin, ListView):
        model = Comment
        select_related = ('article',)

    # will perform Comment.objects.select_related('article')


Combining
---------

.. sourcecode:: python

    class MyCommentsListView(LoginRequiredMixin, UserQuerysetMixin,
                            SelectRelatedMixin, ListView):
        model = Comment
        select_related = ('article',)

    # Comment.objects.filter(user=user).select_related('article')


Presentation
------------

* **Views**: :gray:`definition, contrived examples.`
* **Class-based views**: :gray:`making views out of classes.`
* **Generic views**: :gray:`history, comparison, implementation.`
* **Mixins**: :gray:`building blocks for reusable views.`
* **Tips**: :navy:`making it harder to shoot yourself in the foot.`


In practice
-----------

Only a few attributes/methods are commonly changed:

* **Attributes**: ``template_name``, ``model``, ``form_class``,
                  ``pk_url_kwarg``, ``context_object_name``, ...

* **Methods**: ``get_queryset``, ``get_form_kwargs``, ``get_form_initial``, ...


Tips for not shooting yourself in the foot
------------------------------------------

Fallback to ``generic.View`` if the code gets messy.

Keep your mixins simple: they should only do one thing.

Keep your inheritance chain simple: have your mixins inherit from ``object``.

Only inherit from one single view (with mixins on the left).

Don't break the chain: always call ``super(...)``.


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


Conclusion
----------

* Generic views are awesome
* Class-based views are awesome
* Mixins are awesome
* But you can keep using regular functions, they'll always work.


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


Bonus: simplified ``generic.View``
----------------------------------

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
