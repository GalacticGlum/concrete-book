\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{concrete-book}

\LoadClass{scrbook}
\RequirePackage{geometry}
\RequirePackage[calcwidth]{titlesec}
\RequirePackage{calc}
\RequirePackage{marginnote}
\RequirePackage{changepage}
\RequirePackage[T1]{fontenc}
\RequirePackage{helvet}
\RequirePackage{fancyhdr}
\RequirePackage{titletoc}
\RequirePackage{xcolor}

% Set koma font to use computer modern family.
\addtokomafont{disposition}{\rmfamily}
\addtokomafont{chapter}{\rmfamily}
\addtokomafont{chapterentry}{\rmfamily}

% Document geometry
\newgeometry{top=2.1cm, bottom=2.1cm, inner=4.3cm, outer=2.2cm, 
    footskip=0.8cm, marginparsep=0.5cm, marginparwidth=2.8cm, reversemarginpar,
    headsep=0.6cm}
    
\savegeometry{content}

% Header and footer configuration
\pagestyle{fancy}

\newlength{\pagenumerboxlen}
\newcommand{\recalcPagenumerboxlen}{\setlength{\pagenumerboxlen}{0.4cm + \widthof{\thepage}}}

\newcommand{\rpagenumerbox}{\rlap{\mbox{\hspace{0.4cm}\thepage}}}
\newcommand{\lpagenumerbox}{\recalcPagenumerboxlen\hspace{-\pagenumerboxlen}\makebox[\pagenumerboxlen][l]{\thepage}}

\cfoot{}
\fancyhead{}
\fancyhead[RO]{\rightmark\rpagenumerbox}
\fancyhead[LE]{\lpagenumerbox\leftmark}

\renewcommand{\headrulewidth}{0pt}

\renewcommand{\chaptermark}[1]{%
 \markboth{\textbf{\MakeUppercase{#1}}}{\textbf{\MakeUppercase{#1}}}%
}

\renewcommand{\sectionmark}[1]{%
\markright{\textbf{\MakeUppercase{\thesection\ #1}}}}

% chapter title format
\newcommand{\lmr}{\fontfamily{lmr}\selectfont} % Latin Modern Roman

\newlength\chapterrulelen
\setlength\chapterrulelen{\dimexpr\marginparwidth+\marginparsep+\hoffset\relax}

\titleformat{\chapter}[display]
    {\normalfont\Huge\bfseries\justifyifodd}
    {\lmr\fontsize{86}{0}\selectfont \thechapter}
    {2.6cm}{}
    [\if@mainmatter\vspace{-1.5ex}{\makebox[\linewidth][l]{%
    \hspace*{-\chapterrulelen}\rule{\dimexpr\textwidth+\chapterrulelen\relax}{0.5pt}}}\fi]

\titlespacing*{\chapter}
  {0pt}
  {0pt}
  {\if@mainmatter{2ex}\else{3.5ex}\fi}
  
% Table of contents formatting
\KOMAoptions{toc=chapterentrydotfill}

% Part command with custom geometry logic
\let\oldpart\part
\renewcommand{\part}[1]
{
    \restoregeometry
    \oldpart{#1}
    \loadgeometry{content}
}


\newcommand{\justifyifodd}{}

\let\oldmainmatter\mainmatter
\renewcommand{\mainmatter}
{
    \oldmainmatter
    \loadgeometry{content}
    \renewcommand{\justifyifodd}{
        \checkoddpage
        \ifoddpage\raggedleft\else\fi
    }
    
    \setcounter{page}{1}
    
    % A possible fix to the marginnote page count
    % issue if it shall arise again. This sets the
    % internal page counter in the marginnotes
    % package to page 1.
    % \gdef\themn@abspage{1}
}

% Margin notes configuration
\renewcommand*{\marginfont}{\noindent\small\slshape}
\renewcommand*{\raggedleftmarginnote}{\raggedrightmarginnote}

% Title page
\newcommand{\makesimpletitle}{%
    \vspace*{20ex}
    {\sffamily\fontsize{40}{48}\bfseries\@title}
    \vskip 6ex
    {\huge\ifdefedition\sffamily{\@edition}\else\bfseries\@subtitle\fi}
    \ifx\@dedication\@empty \else
    \vfill
    {\LARGE\itshape\@dedication}
    \fi
}

\newif\ifdefedition
\let\@edition\@empty
\newcommand{\edition}[1]{\gdef\@edition{#1}\defeditiontrue}

\newcommand{\titleauthorformat}[1]{\MakeUppercase{#1}}

\newcommand{\makecomplextitle}{%
    \vspace*{20ex}
    {\sffamily\fontsize{40}{48}\bfseries\@title}
    
    \vskip 6ex
    
    \ifx\@subtitle\@empty \else
    \parbox{\textwidth}{%
        {\huge\bfseries\@subtitle\par}
    }
    
    \vskip 6ex
    \fi


    \ifx\@subtitle\@empty
    {\sffamily\huge\@edition}
    \vskip 6ex 
    \else
    {\sffamily\LARGE\@edition}
    \fi
    
    \vskip 4cm
    \foreach \name in \@author {%
        {\edef\tmp{\noexpand\titleauthorformat{\name}}{\sffamily\large\tmp}\par\vspace{1.5ex}}
    }
}

% {\edef\tmp{}\tmp}

\RequirePackage{pgffor}

\renewcommand{\maketitle}{%
    \cleardoubleoddpage
    \pagenumbering{gobble}

    \newgeometry{left=3cm, right=3cm, bottom=3cm, top=3cm}
    \pagestyle{empty}
    \makesimpletitle
    \cleardoubleoddpage
    \makecomplextitle
    \restoregeometry
    
    \pagestyle{fancy}
    \cleardoubleoddpage
    \pagenumbering{roman}
}