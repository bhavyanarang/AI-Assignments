from durable.lang import *

print("Enter cgpa ")
cgpa=float(input())

print("Which branch are you interested in : ")
print("cse, ai, or ece")
branch=input().strip()

print("Which extracurricular activity you interested in?")
activity=input().strip()

print("What is the level that you have pursued this activity till?")
print("state, national or hobby")
level=input().strip()

with ruleset('toassert'):
    @when_all(m.do=='1')
    def assertt(b):
        b.assert_fact('input', {'branch': branch})
        b.assert_fact('extracurricular', {'level': level, 'activity': activity})

with ruleset('input'):

    @when_all(m.branch=='ai')
    def ai(c):
        print("Have you done Machine learning course?")
        done=input().strip()
        c.assert_fact('fundamental_courses', {'done': done,'branch':'ai'})

    @when_all(m.branch=='ece')
    def ece(c):
        print("Have you done ELD course?")
        done = input().strip()
        c.assert_fact('fundamental_courses', {'done': done, 'branch': 'ece'})

    @when_all(m.branch=='cse')
    def cse(c):
        print("Have you done DSA course? ")
        done = input().strip()
        c.assert_fact('fundamental_courses', {'done': done, 'branch': 'cse'})


with ruleset('fundamental_courses'):

    @when_all((m.branch=='ai') & (m.done=='no'))
    def do_fundamental(d):
        d.assert_fact({'prediction': 'You can take Machine Learning Course'})
        d.assert_fact({'prediction': 'You can take Statistical Machine Learning Course'})

    @when_all((m.branch == 'cse') & (m.done == 'no'))
    def do_fundamental(d):
        d.assert_fact({'prediction': 'You can take DSA course'})
        d.assert_fact({'prediction': 'You can take Analysis and Design of Algorithms'})

    @when_all((m.branch == 'ece') & (m.done == 'no'))
    def do_fundamental(d):
        d.assert_fact({'prediction': 'You can take ELD course'})
        d.assert_fact({'prediction': 'You can take Signal and Systems'})

    @when_all(m.done == 'yes')
    def btp(d):
        d.assert_fact('btp',{'cgpa':cgpa})
        d.assert_fact('all_rounder',{'cgpa':cgpa,'activity':activity,'level':level})


    @when_all((m.branch == 'cse') & (m.done == 'yes'))
    def do_advanced(d):
        d.assert_fact({'prediction': 'You can take Modern Algorithm course'})
        d.assert_fact({'prediction': 'You can take Advanced Programming course'})

    @when_all((m.branch == 'ai') & (m.done == 'yes'))
    def do_advanced(d):
        d.assert_fact({'prediction': 'You can take Computer Vision course'})
        d.assert_fact({'prediction': 'You can take Natural Language Processing course'})

    @when_all((m.branch == 'ece') & (m.done == 'yes'))
    def do_advanced(d):
        d.assert_fact({'prediction': 'You can take Advanced ELD course'})
        d.assert_fact({'prediction': 'You can take CMOS design course'})

    @when_all(+m.prediction)
    def output(d):
        print('{0}'.format(d.m.prediction))

with ruleset('btp'):
    @when_all((m.cgpa>=8))
    def take_btp(e):
        e.assert_fact({'prediction': 'You can also take a btp in '+branch})

    @when_all(+m.prediction)
    def output(e):
        print('{0}'.format(e.m.prediction))

with ruleset('all_rounder'):
    @when_all((m.cgpa >= 8) & ((m.level=='state') | (m.level=='national')))
    def all_round_performance(f):
        f.assert_fact({'prediction': 'Congrats! You are an all-rounder !!'})

    @when_all(+m.prediction)
    def output(f):
        print('{0}'.format(f.m.prediction))

with ruleset('extracurricular'):
    @when_all((m.level=='state') | (m.level=='national'))
    def takeup(g):
        g.assert_fact({'prediction':'You can take up '+activity})

    @when_all(+m.prediction)
    def output(g):
        print('{0}'.format(g.m.prediction))

assert_fact('toassert',{'do':'1'})
